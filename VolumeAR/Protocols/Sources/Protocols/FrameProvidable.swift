//
//  FrameProvidable.swift
//  Protocols
//
//  Created by SONG on 8/3/25.
//

import ARKit

public protocol FrameProvidable: Sendable {
    var currentCameraTransform: simd_float4x4? { get }
    func updateSession(_ session: ARSession)
}
