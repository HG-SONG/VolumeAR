//
//  HapticManagable.swift
//  Protocols
//
//  Created by SONG on 8/4/25.
//

import CoreGraphics

public protocol HapticManagable {
    func impactIfNeeded(offset: CGFloat)

    func triggerImpact()
}
