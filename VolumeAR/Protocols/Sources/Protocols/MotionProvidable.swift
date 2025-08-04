//
//  MotionProvidable.swift
//  Protocols
//
//  Created by SONG on 8/4/25.
//

import CoreMotion

public protocol MotionProvidable {
    var updateHandler: ((CMDeviceMotion) -> Void)? { get set }
    func start()
    func stop()
}
