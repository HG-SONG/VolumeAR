//
//  ARSessionFrameProvider.swift
//  SurfaceDetection
//
//  Created by SONG on 8/3/25.
//

import ARKit
import Protocols

public struct ARSessionFrameProvider: FrameProvidable {
    public init() {}

    public func currentCameraTransform(from session: ARSession) -> simd_float4x4? {
        return session.currentFrame?.camera.transform
    }
}
