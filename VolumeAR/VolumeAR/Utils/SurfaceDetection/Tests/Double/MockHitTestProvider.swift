//
//  MockHitTestProvider.swift
//  SurfaceDetection
//
//  Created by SONG on 8/4/25.
//

import ARKit
import VolumeEntities
import Protocols

public final class MockHitTestProvider: HitTestProvidable {
    private let points: [HitTestPoint]

    public init(points: [HitTestPoint]) {
        self.points = points
    }

    public func hitTest(at point: CGPoint, in cameraView: ARSCNView) async -> [HitTestPoint] {
        return points
    }
}
