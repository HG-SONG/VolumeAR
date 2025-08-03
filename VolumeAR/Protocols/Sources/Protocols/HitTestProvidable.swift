//
//  HitTestProvidable.swift
//  Protocols
//
//  Created by SONG on 8/3/25.
//

import ARKit
import VolumeEntities

public protocol HitTestProvidable: Sendable {
    func hitTest(at point: CGPoint, in cameraView: ARSCNView) async -> [HitTestPoint]
}
