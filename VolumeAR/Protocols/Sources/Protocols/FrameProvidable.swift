//
//  FrameProvidable.swift
//  Protocols
//
//  Created by SONG on 8/3/25.
//

import ARKit

public protocol FrameProvidable {
    func currentCameraTransform(from session: ARSession) -> simd_float4x4?
}
