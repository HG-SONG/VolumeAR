//
//  AppCore.swift
//  AppCore
//
//  Created by SONG on 8/3/25.
//

import UIKit
import VolumeEntities
import Protocols
import SurfaceDetection
import MeasureScene

@MainActor
public final class AppCore {
    private let window: UIWindow

    public init(window: UIWindow) {
        self.window = window
    }

    public func start() {
        let rootVC = makeMeasureViewController()
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
    }

    private func makeMeasureViewController() -> UIViewController {
        let surfaceManager = SurfaceManager()

        let rootVC = MeasureViewController(surfaceManager: surfaceManager)
        return rootVC
    }
}
