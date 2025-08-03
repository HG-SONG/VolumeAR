//
//  SurfaceTracker.swift
//  VolumeAR
//
//  Created by SONG on 8/1/25.
//

import ARKit
import Combine

final class SurfaceTracker: NSObject, ARSCNViewDelegate {
    let modePublisher = CurrentValueSubject<Mode, Never>(.searching)
    private let cameraTransformSubject = PassthroughSubject<simd_float4x4, Never>()
    var cameraTransformPublisher: AnyPublisher<simd_float4x4, Never> {
        cameraTransformSubject.eraseToAnyPublisher()
    }
    
    private func updateMode(for sceneView: ARSCNView) {
        let center = CGPoint(x: sceneView.bounds.midX, y: sceneView.bounds.midY)
        let results = sceneView.hitTest(center, types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane, .estimatedVerticalPlane])
        
        if results.first != nil {
            modePublisher.send(.idle)
        } else {
            modePublisher.send(.searching)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let cameraView = renderer as? ARSCNView else { return }
        Task { @MainActor in updateMode(for: cameraView) }
        
        if let frame = cameraView.session.currentFrame {
            cameraTransformSubject.send(frame.camera.transform)
        }
    }
}
