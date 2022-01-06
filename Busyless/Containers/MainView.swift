//
//  MainView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/12/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import BusylessDataLayer

struct MainView: View {

    // MARK: - Private Properties

    @State private var isOnboardingPresented = false
    @State private var isAddNewActivityPresented = false
    
    @Environment(\.managedObjectContext)
    private var managedObjectContext

    @AppStorage("shouldShowInitialOnboarding")
    private var shouldShowInitialOnboarding = true

    // MARK: - Lifecycle

    var body: some View {
        ZStack {
            TabView {
                LogView().tabItem { Label("Activities", systemImage: "list.dash") }
                DayView().tabItem { Label("Day", systemImage: "sun.min") }
                Text("New").tabItem { }
                MonthView().tabItem { Label("Month", systemImage: "calendar") }
                SettingsView().tabItem { Label("Settings", systemImage: "gear") }
            }
            VStack {
                Spacer()
                AddButton {
                    isAddNewActivityPresented.toggle()
                }.padding(-15)
            }.sheet(isPresented: $isAddNewActivityPresented) {
                AddNewActivityView(activity: nil) {
                    isAddNewActivityPresented = false
                }.environment(\.managedObjectContext, managedObjectContext)
            }
        }.onAppear {
            // TODO: Cleanup onboarding and re-add
            // showOnboardingIfNeeded()
        }.sheet(isPresented: $isOnboardingPresented) {
            InitialOnboardingView()
        }
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return Group {
            MainView().environment(\.managedObjectContext, context)
        }
    }
}
