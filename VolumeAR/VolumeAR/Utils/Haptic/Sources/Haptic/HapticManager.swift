//
//  HapticManager.swift
//  VolumeAR
//
//  Created by SONG on 8/2/25.
//

import UIKit
import Protocols

@MainActor
public final class HapticManager: HapticManagable {
    private let impactGenerator: FeedbackGenerator
    private let threshold: CGFloat
    private var wasOffsetOutsideThreshold = false
    
    public init(threshold: CGFloat = 0.05, impactGenerator: FeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)) {
        self.threshold = threshold
        self.impactGenerator = impactGenerator
        self.impactGenerator.prepare()
    }
    
    public func impactIfNeeded(offset: CGFloat) {
        let isInside = abs(offset) < threshold
        
        if isInside && wasOffsetOutsideThreshold {
            impactGenerator.impactOccurred()
        }
        
        wasOffsetOutsideThreshold = !isInside
    }
    
    public func triggerImpact() {
        impactGenerator.impactOccurred()
    }
}

extension UIImpactFeedbackGenerator: @retroactive FeedbackGenerator {}
