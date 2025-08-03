//
//  SceneDelegate.swift
//  VolumeAR
//
//  Created by SONG on 8/1/25.
//

import UIKit
import AppCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCore: AppCore?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.appCore = AppCore(window: window)
        self.appCore?.start()
    }
}

