//
//  MockFrameProvider.swift
//  SurfaceDetection
//
//  Created by SONG on 8/4/25.
//

import ARKit
import VolumeEntities
import Protocols

public final class MockFrameProvider: FrameProvidable {
    private let transform: simd_float4x4?

    public init(transform: simd_float4x4?) {
        self.transform = transform
    }

    public func currentCameraTransform(from session: ARSession) -> simd_float4x4? {
        return transform
    }
}
