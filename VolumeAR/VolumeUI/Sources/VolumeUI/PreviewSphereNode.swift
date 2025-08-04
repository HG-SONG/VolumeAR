//
//  PreviewSphereNode.swift
//  VolumeUI
//
//  Created by SONG on 8/4/25.
//

import SceneKit

public final class PreviewSphereNode: SCNNode {
    private let sphereGeometry: SCNSphere

    public override init() {
        sphereGeometry = SCNSphere(radius: 0.02)
        sphereGeometry.firstMaterial?.diffuse.contents = UIColor.systemYellow.withAlphaComponent(0.75)
        super.init()
        self.geometry = sphereGeometry
        self.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func update(position: SCNVector3) {
        self.position = position
        self.isHidden = false
    }

    public func hide() {
        self.isHidden = true
    }
}
