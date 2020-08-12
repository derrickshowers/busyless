//
//  SceneDelegate.swift
//  TimeBudget
//
//  Created by Derrick Showers on 8/8/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene,
            let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
                return
        }

        let dayView = MainView().environment(\.managedObjectContext, context)
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: dayView)
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
