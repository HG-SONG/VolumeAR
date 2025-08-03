//
//  SurfaceManagable.swift
//  Protocols
//
//  Created by SONG on 8/3/25.
//

import ARKit
import Combine
import VolumeEntities

@MainActor
public protocol SurfaceManagable: ARSCNViewDelegate, AnyObject {
    var modePublisher: CurrentValueSubject<Mode, Never> { get }
    var cameraTransformPublisher: AnyPublisher<simd_float4x4, Never> { get }
}
