//
//  HitTestPoint.swift
//  VolumeEntities
//
//  Created by SONG on 8/4/25.
//

import ARKit

public struct HitTestPoint: Sendable {
    public let worldTransform: simd_float4x4
    public init(worldTransform: simd_float4x4) {
        self.worldTransform = worldTransform
    }
}
