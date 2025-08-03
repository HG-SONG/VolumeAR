//
//  SurfaceManagerTests.swift
//  SurfaceDetection
//
//  Created by SONG on 8/4/25.
//

import XCTest
import ARKit
import VolumeEntities
@testable import SurfaceDetection // 너의 모듈명

final class SurfaceManagerTests: XCTestCase {
    @MainActor
    func testIdleModeWhenHitTestReturnsPoint() {
        let fakePoint = HitTestPoint(worldTransform: matrix_identity_float4x4)
        let hitProvider = MockHitTestProvider(points: [fakePoint])
        let frameProvider = MockFrameProvider(transform: matrix_identity_float4x4)
        let surfaceManager = SurfaceManager(
            raycastProvider: hitProvider,
            frameProvider: frameProvider
        )

        let sceneView = ARSCNView()
        var receivedMode: Mode?
        let expectation = expectation(description: "Wait")

        let cancellable = surfaceManager.modePublisher
            .sink { mode in
                receivedMode = mode
                if mode == .idle {
                    expectation.fulfill()
                }
            }

        surfaceManager.renderer(sceneView, updateAtTime: 0)

        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()

        XCTAssertEqual(receivedMode, .idle)
    }

    @MainActor
    func testSearchingModeWhenHitTestReturnsEmpty() {
        let hitProvider = MockHitTestProvider(points: [])
        let frameProvider = MockFrameProvider(transform: matrix_identity_float4x4)
        let surfaceManager = SurfaceManager(
            raycastProvider: hitProvider,
            frameProvider: frameProvider
        )

        let sceneView = ARSCNView()
        var receivedMode: Mode?
        let expectation = expectation(description: "Wait")

        let cancellable = surfaceManager.modePublisher
            .sink { mode in
                receivedMode = mode
                if mode == .searching {
                    expectation.fulfill()
                }
            }

        surfaceManager.renderer(sceneView, updateAtTime: 0)

        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()

        XCTAssertEqual(receivedMode, .searching)
    }

}
