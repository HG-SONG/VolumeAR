////
////  HapticManager.swift
////  VolumeAR
////
////  Created by SONG on 8/2/25.
////
//
//import UIKit
//
//final class HapticManager {
//    static let shared = HapticManager()
//    
//    private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
//    private let threshold: CGFloat
//    private var wasOffsetOutsideThreshold = false
//    
//    private init(threshold: CGFloat = 0.05) {
//        self.threshold = threshold
//        impactGenerator.prepare()
//    }
//    
//    func impactIfNeeded(offset: CGFloat) {
//        let isInside = abs(offset) < threshold
//        
//        if isInside && wasOffsetOutsideThreshold {
//            impactGenerator.impactOccurred()
//        }
//        
//        wasOffsetOutsideThreshold = !isInside
//    }
//    
//    func triggerImpact() {
//        impactGenerator.impactOccurred()
//    }
//}
