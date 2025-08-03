//
//  ARSessionRaycastProvider.swift
//  SurfaceDetection
//
//  Created by SONG on 8/3/25.
//

import ARKit
import Protocols
import VolumeEntities

public final class ARSCNViewHitTestProvider: HitTestProvidable {
    public init() {}

    @MainActor
    public func hitTest(at point: CGPoint, in cameraView: ARSCNView) async -> [HitTestPoint] {
        let types: ARHitTestResult.ResultType = [
            .existingPlaneUsingExtent,
            .estimatedHorizontalPlane,
            .featurePoint
        ]
        
        let results = cameraView.hitTest(point, types: types)
        return results.map { HitTestPoint(worldTransform: $0.worldTransform) }
    }
}
