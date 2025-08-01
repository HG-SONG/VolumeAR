//
//  SurfaceIndicatorNode.swift
//  VolumeAR
//
//  Created by SONG on 8/1/25.
//

import SceneKit
import simd

final class SurfaceIndicatorNode: SCNNode {
    private let circleGeometry: SCNCylinder
    private let material: SCNMaterial

    override init() {
        circleGeometry = SCNCylinder(radius: 0.05, height: 0.001)
        material = SCNMaterial()
        super.init()
        setupGeometry()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupGeometry() {
        material.diffuse.contents = UIColor.systemBlue.withAlphaComponent(0.8)
        material.isDoubleSided = true
        material.lightingModel = .constant
        circleGeometry.materials = [material]
        geometry = circleGeometry
        eulerAngles.x = -.pi / 2
    }

    func updateTransform(position: simd_float3, normal: simd_float3, scale: Float) {
         self.simdPosition = position

         // 회전변환 조져
         let up = simd_float3(0, 1, 0)
         let axis = simd_cross(up, normal)
         let angle = acos(simd_dot(up, simd_normalize(normal)))
         if simd_length(axis) > 0.001 {
             self.simdOrientation = simd_quatf(angle: angle, axis: simd_normalize(axis))
         } else {
             self.simdOrientation = simd_quatf(angle: 0, axis: up)
         }

         self.simdScale = simd_float3(repeating: scale)
     }
}

