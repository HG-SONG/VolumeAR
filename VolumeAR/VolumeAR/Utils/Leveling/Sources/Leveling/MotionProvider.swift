//
//  MotionProvider.swift
//  Leveling
//
//  Created by SONG on 8/4/25.
//

import CoreMotion
import Protocols

public final class MotionProvider: MotionProvidable {
    private let motion = CMMotionManager()
    public var updateHandler: ((CMDeviceMotion) -> Void)?

    public init() {}

    public func start() {
        guard motion.isDeviceMotionAvailable else { return }
        motion.deviceMotionUpdateInterval = 1.0 / 60.0
        motion.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical, to: .main) { [weak self] dm, _ in
            if let dm = dm {
                self?.updateHandler?(dm)
            }
        }
    }

    public func stop() {
        motion.stopDeviceMotionUpdates()
    }
}
