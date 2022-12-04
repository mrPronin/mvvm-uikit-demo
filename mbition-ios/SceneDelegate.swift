//
//  SceneDelegate.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowsScene)
        window?.rootViewController = UINavigationController(rootViewController: UserList.vc)
        
        window?.makeKeyAndVisible()
    }
}

