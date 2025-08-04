//
//  MockMotionProvider.swift
//  Leveling
//
//  Created by SONG on 8/4/25.
//

import CoreMotion
import Protocols

public final class MockDeviceMotionProvider: MotionProvidable {
    public var updateHandler: ((CMDeviceMotion) -> Void)?
    public init() {}

    public func start() { }
    public func stop() { }

    public func send(_ dm: CMDeviceMotion) {
        updateHandler?(dm)
    }
}
