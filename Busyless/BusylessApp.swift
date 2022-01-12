//
//  Busyless.swift
//  Busyless
//
//  Created by Derrick Showers on 8/8/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import BusylessDataLayer
import CoreData

@main
struct BusylessApp: App {

    // MARK: - Private Properties

    private let persistenceController = PersistenceController.shared
    @ObservedObject private var dataStore: DataStore
    @AppStorage("shouldAddMockData") private var shouldAddMockData = true

    // MARK: - Lifecycle

    init() {
        dataStore = BusylessApp.createDataStore(with: persistenceController.container.viewContext)
        setupOnboarding(dataStore: dataStore)
        setupNavigationBar()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.dataStore, _dataStore)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    dataStore.activityStore.fetch()
                }
        }
    }

    // MARK: - Setup

    private static func createDataStore(with managedObjectContext: NSManagedObjectContext) -> DataStore {
        return DataStore(managedObjectContext: managedObjectContext)
    }

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

    private func setupOnboarding(dataStore: DataStore) {
        guard shouldAddMockData else {
            return
        }

        // Add a delay to give a chance for iCloud data to be fetched.
        // Unfortunately there doesn't seem to be a better way to know if iCloud request was completed.
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            let wasOnboardingDataAdded = dataStore.addOnboardingData()
            shouldAddMockData = wasOnboardingDataAdded
        }
    }
}
