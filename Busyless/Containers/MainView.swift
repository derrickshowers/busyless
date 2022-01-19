//
//  MainView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/12/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import BusylessDataLayer
import SwiftUI

struct MainView: View {
    // MARK: - Private Properties

    @ObservedObject private var viewModel: MainViewModel

    @State private var isOnboardingPresented = false
    @State private var isAddNewActivityPresented = false

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    @Environment(\.colorScheme)
    private var colorScheme

    @AppStorage("shouldShowInitialOnboarding")
    private var shouldShowInitialOnboarding = true

    // MARK: - Lifecycle

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        UITabBar.appearance().backgroundColor = UIColor(Color.tabBarBackground)
    }

    var body: some View {
        ZStack {
            TabView {
                viewModel.logView.tabItem { Label("Activities", systemImage: "list.dash") }
                DayView().tabItem { Label("Day", systemImage: "sun.min") }
                Text("New").tabItem {}
                MonthView().tabItem { Label("Month", systemImage: "calendar") }
                SettingsView().tabItem { Label("Settings", systemImage: "gear") }
            }
            .accentColor(colorScheme == .light ? .mainColor : .secondaryColor)
            VStack {
                Spacer()
                AddButton {
                    isAddNewActivityPresented.toggle()
                }.padding(-15)
            }.sheet(isPresented: $isAddNewActivityPresented) {
                NavigationView {
                    viewModel.addNewActivityView
                }
            }
        }.onAppear {
            // TODO: Cleanup onboarding and re-add
            // showOnboardingIfNeeded()
        }.sheet(isPresented: $isOnboardingPresented) {
            InitialOnboardingView()
        }.navigationViewStyle(.stack)
    }

    // MARK: - Private Methods

    private func showOnboardingIfNeeded() {
        guard shouldShowInitialOnboarding else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isOnboardingPresented = true
            shouldShowInitialOnboarding = false
        }
    }
}

// MARK: - Testing/Previews

extension MainView {
    static func forTesting() -> MainView {
        let mockDataStore = DataStore(managedObjectContext: PersistenceController.preview.container.viewContext)
        let mockLogViewModel = LogViewModel(dataStore: mockDataStore) { _ in AddNewActivityView.forTesting() }
        let mockViewModel = MainViewModel(addNewActivityView: AddNewActivityView.forTesting(),
                                          logView: LogView(viewModel: mockLogViewModel))
        return Self(viewModel: mockViewModel)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            MainView.forTesting()
        }
    }
}
