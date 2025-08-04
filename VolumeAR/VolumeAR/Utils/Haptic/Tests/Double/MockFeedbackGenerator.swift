//
//  MockFeedbackGenerator.swift
//  Haptic
//
//  Created by SONG on 8/4/25.
//

import Protocols

public final class MockFeedbackGenerator: FeedbackGenerator {
    public private(set) var didPrepare = false
    public private(set) var impactCalls = 0

    public init() {}

    public func prepare() {
        didPrepare = true
    }

    public func impactOccurred() {
        impactCalls += 1
    }
}
