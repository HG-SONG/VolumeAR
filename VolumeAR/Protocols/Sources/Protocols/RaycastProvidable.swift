//
//  RaycastProvidable.swift
//  Protocols
//
//  Created by SONG on 8/3/25.
//

import ARKit
import Foundation

public protocol RaycastProvidable {
    func raycast(_ query: ARRaycastQuery) -> [ARRaycastResult]
    func updateSession(_ session: ARSession)
}
