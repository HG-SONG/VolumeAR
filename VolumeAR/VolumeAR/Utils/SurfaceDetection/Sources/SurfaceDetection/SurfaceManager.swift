//
//  SurfaceManager.swift
//  VolumeAR
//
//  Created by SONG on 8/1/25.
//

import ARKit
import Combine
import VolumeEntities
import Protocols
import UIKit

@MainActor
public final class SurfaceManager: NSObject, SurfaceManagable {
    private let hitTestProvider: HitTestProvidable
    private let frameProvider: FrameProvidable
    private let cameraTransformSubject = PassthroughSubject<simd_float4x4, Never>()
    private let hitTestTransformSubject = CurrentValueSubject<simd_float4x4?, Never>(nil)
    
    public let modePublisher = CurrentValueSubject<Mode, Never>(.searching)
    public var cameraTransformPublisher: AnyPublisher<simd_float4x4, Never> {
        cameraTransformSubject.eraseToAnyPublisher()
    }
    public var hitTestTransformPublisher: AnyPublisher<simd_float4x4?, Never> {
        hitTestTransformSubject.eraseToAnyPublisher()
    }

    public init(
        hitTestProvider: HitTestProvidable = ARSCNViewHitTestProvider(),
        frameProvider: FrameProvidable = ARSessionFrameProvider()
    ) {
        self.hitTestProvider = hitTestProvider
        self.frameProvider = frameProvider
        super.init()
    }

    @MainActor
    private func determineModeAndHitTest(with cameraView: ARSCNView) async -> (mode: Mode, hitTransform: simd_float4x4?) {
        let center = CGPoint(x: cameraView.bounds.midX, y: cameraView.bounds.midY)
        let rawResults = await hitTestProvider.hitTest(at: center, in: cameraView)
        let cameraPos: SIMD3<Float>
        if let pov = cameraView.pointOfView {
            let cam4 = pov.simdTransform.columns.3
            cameraPos = SIMD3<Float>(cam4.x, cam4.y, cam4.z)
        } else {
            cameraPos = SIMD3<Float>(0, 0, 0)
        }

        let filtered = rawResults.filter { result in
            let res4 = result.worldTransform.columns.3
            let resPos = SIMD3<Float>(res4.x, res4.y, res4.z)
            let distance = simd_length(resPos - cameraPos)
            print("Distance from camera:", distance)
            return distance >= 0.1 && distance <= 3.0
        }

        let preferred = filtered.min { lhs, rhs in
            let lhsPos = SIMD3<Float>(
                lhs.worldTransform.columns.3.x,
                lhs.worldTransform.columns.3.y,
                lhs.worldTransform.columns.3.z
            )
            let rhsPos = SIMD3<Float>(
                rhs.worldTransform.columns.3.x,
                rhs.worldTransform.columns.3.y,
                rhs.worldTransform.columns.3.z
            )
            
            return simd_length(lhsPos - cameraPos) < simd_length(rhsPos - cameraPos)
        }

        
        let mode: Mode = preferred != nil ? .idle : .searching
        let hitTransform = preferred?.worldTransform

        return (mode, hitTransform)
    }


    private func publishMode(_ mode: Mode) {
        self.modePublisher.send(mode)
    }
    
    private func publishHitTransform(_ transform: simd_float4x4?) {
        self.hitTestTransformSubject.send(transform)
    }
    

    nonisolated public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let cameraView = renderer as? ARSCNView else { return }

        Task { @MainActor in
            let (mode, hitTransform) = await determineModeAndHitTest(with: cameraView)
            publishMode(mode)
            publishHitTransform(hitTransform)
        
            if let transform = frameProvider.currentCameraTransform(from: cameraView.session) {
                cameraTransformSubject.send(transform)
            }
        }
    }
}

