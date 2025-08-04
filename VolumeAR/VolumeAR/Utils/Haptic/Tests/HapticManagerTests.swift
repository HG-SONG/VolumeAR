//
//  HapticManagerTests.swift
//  Haptic
//
//  Created by SONG on 8/4/25.
//

import XCTest
import UIKit
@testable import Haptic

final class HapticManagerTests: XCTestCase {

    @MainActor
    func testTriggerImpact_alwaysCallsImpact() {
        let spy = MockFeedbackGenerator()
        let manager = HapticManager(threshold: 0.05, impactGenerator: spy)

        manager.triggerImpact()
        manager.triggerImpact()

        XCTAssertEqual(spy.impactCalls, 2)
        XCTAssertTrue(spy.didPrepare)
    }

    @MainActor
    func testImpactIfNeeded_outsideToInside_triggersOnce() {
        let spy = MockFeedbackGenerator()
        let manager = HapticManager(threshold: 0.1, impactGenerator: spy)

        manager.impactIfNeeded(offset: 0.2)
        XCTAssertEqual(spy.impactCalls, 0)

        manager.impactIfNeeded(offset: 0.0)
        XCTAssertEqual(spy.impactCalls, 1)

        manager.impactIfNeeded(offset: 0.05)
        XCTAssertEqual(spy.impactCalls, 1)
    }

    @MainActor
    func testImpactIfNeeded_insideToOutside_thenBackInside_triggersTwice() {
        let spy = MockFeedbackGenerator()
        let manager = HapticManager(threshold: 0.1, impactGenerator: spy)

        manager.impactIfNeeded(offset: 0.2)
        manager.impactIfNeeded(offset: 0.0)
        XCTAssertEqual(spy.impactCalls, 1)

        manager.impactIfNeeded(offset: 0.3)
        XCTAssertEqual(spy.impactCalls, 1)

        manager.impactIfNeeded(offset: 0.0)
        XCTAssertEqual(spy.impactCalls, 2)
    }

    @MainActor
    func testImpactIfNeeded_staysOutside_neverTriggers() {
        let spy = MockFeedbackGenerator()
        let manager = HapticManager(threshold: 0.1, impactGenerator: spy)

        manager.impactIfNeeded(offset: 0.2)
        manager.impactIfNeeded(offset: 0.15)
        manager.impactIfNeeded(offset: 0.11)
        XCTAssertEqual(spy.impactCalls, 0)
    }

    @MainActor
    func testCustomThreshold_behavesAccordingly() {
        let spy = MockFeedbackGenerator()
        let manager = HapticManager(threshold: 0.5, impactGenerator: spy)
        manager.impactIfNeeded(offset: 0.6)
        manager.impactIfNeeded(offset: 0.1)
        XCTAssertEqual(spy.impactCalls, 1)
        manager.impactIfNeeded(offset: 0.55)
        manager.impactIfNeeded(offset: 0.2)
        XCTAssertEqual(spy.impactCalls, 2)
    }
}
