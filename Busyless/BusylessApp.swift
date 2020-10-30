//
//  Busyless.swift
//  Busyless
//
//  Created by Derrick Showers on 8/8/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import BusylessDataLayer

@main
struct BusylessApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        setupNavigationBar()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor(Color.mainColor)
        navigationBarAppearance.titleTextAttributes.updateValue(UIColor.white, forKey: NSAttributedString.Key.foregroundColor)
        navigationBarAppearance.largeTitleTextAttributes.updateValue(UIColor.white, forKey: NSAttributedString.Key.foregroundColor)

        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance

        UINavigationBar.appearance().tintColor = .white
    }
}
