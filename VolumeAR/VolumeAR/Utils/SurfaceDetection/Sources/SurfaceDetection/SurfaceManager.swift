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

    public let modePublisher = CurrentValueSubject<Mode, Never>(.searching)
    public var cameraTransformPublisher: AnyPublisher<simd_float4x4, Never> {
        cameraTransformSubject.eraseToAnyPublisher()
    }

    public init(
        raycastProvider: HitTestProvidable = ARSCNViewHitTestProvider(),
        frameProvider: FrameProvidable = ARSessionFrameProvider()
    ) {
        self.hitTestProvider = raycastProvider
        self.frameProvider = frameProvider
        super.init()
    }
    
    public func updateARSession(_ session: ARSession) {
        //self.raycastProvider.updateSession(session)
        self.frameProvider.updateSession(session)
    }

    @MainActor
    private func determineMode(with sceneView: ARSCNView) async -> Mode {
        let center = CGPoint(x: sceneView.bounds.midX, y: sceneView.bounds.midY)
        guard let query = sceneView.raycastQuery(from: center, allowing: .estimatedPlane, alignment: .any) else {
            return .searching
        }
        let results = await hitTestProvider.hitTest(at: center, in: sceneView)
        print(results)
        return results.first != nil ? .idle : .searching
    }

    private func publishMode(_ mode: Mode) {
        self.modePublisher.send(mode)
    }

    nonisolated public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let cameraView = renderer as? ARSCNView else { return }

        Task { @MainActor in
            let mode = await determineMode(with: cameraView)
            publishMode(mode)
        }
        
        if let transform = frameProvider.currentCameraTransform {
            Task { @MainActor in
                cameraTransformSubject.send(transform)
            }
        }
    }
}

