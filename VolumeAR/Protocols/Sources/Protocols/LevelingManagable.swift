//
//  LevelingManagable.swift
//  Protocols
//
//  Created by SONG on 8/3/25.
//

import Combine
import ARKit
import VolumeEntities

public protocol LevelingManagable {
    var offsetPublisher: AnyPublisher<LevelOffset, Never> { get }
    func updateCameraTransform(_ cameraTransform: simd_float4x4)
    func start()
    func stop()
}
