//
//  ARSessionRaycastProvider.swift
//  SurfaceDetection
//
//  Created by SONG on 8/3/25.
//

import ARKit
import Protocols

public final class ARSessionRaycastProvider: RaycastProvidable {
    private weak var session: ARSession?
    
    public init() { }
    
    public func raycast(_ query: ARRaycastQuery) -> [ARRaycastResult] {
        session?.raycast(query) ?? []
    }
    
    public func updateSession(_ session: ARSession) {
        self.session = session
    }
}
