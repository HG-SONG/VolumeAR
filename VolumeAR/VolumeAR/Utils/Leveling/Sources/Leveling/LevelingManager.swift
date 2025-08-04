//
//  LevelingManager.swift
//  VolumeAR
//
//  Created by SONG on 8/2/25.
//

import Foundation
import CoreMotion
import ARKit
import Combine
import Protocols
import VolumeEntities

public final class LevelingManager: LevelingManagable {
    private var motionProvider: MotionProvidable
    private let subject = PassthroughSubject<LevelOffset, Never>()
    public var offsetPublisher: AnyPublisher<LevelOffset, Never> {
        subject.eraseToAnyPublisher()
    }

    private var cameraTransform: simd_float4x4?
    
    public init(motionProvider: MotionProvidable = MotionProvider()) {
        self.motionProvider = motionProvider
        self.motionProvider.updateHandler = { [weak self] dm in
            guard let self = self,
                  let camTransform = self.cameraTransform else { return }
            
            self.process(deviceMotion: dm, cameraTransform: camTransform)
        }
    }
    
    public func start() {
        motionProvider.start()
    }

    public func stop() {
        motionProvider.stop()
    }

    public func updateCameraTransform(_ cameraTransform: simd_float4x4) {
        self.cameraTransform = cameraTransform
    }

    private func process(deviceMotion dm: CMDeviceMotion, cameraTransform: simd_float4x4) {
        let forward = -simd_float3(
            cameraTransform.columns.2.x,
            cameraTransform.columns.2.y,
            cameraTransform.columns.2.z
        )
        let horizontalNormal = simd_float3(0, 1, 0)
        let pitchAngle = asin(simd_dot(forward, horizontalNormal))
        let maxAngle = Float.pi / 2
        let yNorm = max(-1, min(1, -pitchAngle / maxAngle))
        subject.send(LevelOffset(x: 0, y: CGFloat(yNorm)))
    }
}
