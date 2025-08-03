//
//  ARSessionFrameProvider.swift
//  SurfaceDetection
//
//  Created by SONG on 8/3/25.
//

import ARKit
import Protocols

public final class ARSessionFrameProvider: FrameProvidable, @unchecked Sendable {
    private let lock = NSLock()
    private weak var session: ARSession?

    public init() { }
    public var currentCameraTransform: simd_float4x4? {
        lock.lock()
        defer { lock.unlock() }
        return session?.currentFrame?.camera.transform
    }

    public func updateSession(_ session: ARSession) {
        lock.lock()
        self.session = session
        lock.unlock()
    }
}

