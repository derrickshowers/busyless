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

    @AppStorage("shouldShowInitialOnboarding")
    private var shouldShowInitialOnboarding = true

    // MARK: - Lifecycle

    var body: some View {
        NavigationView {
            MenuView()
            DayView()
        }.onAppear {
            showOnboardingIfNeeded()
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

struct MenuView: View {

    @State var showOneLevelIn = true

    // MARK: - Lifecycle

    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            NavigationLink(destination: DayView()) {
                Text("Today")
            }
            NavigationLink(destination: MonthView()) {
                Text("This Month")
            }
            NavigationLink(destination: LogView()) {
                Text("Activity Log")
            }
            NavigationLink(destination: SettingsView()) {
                HStack {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            }
            Spacer()

            // For iPhone, let's select day view instead of showing the menu on launch.
            if UIDevice.current.userInterfaceIdiom == .phone {
                NavigationLink(destination: DayView(), isActive: $showOneLevelIn, label: { EmptyView() })
            }
        }
        .font(.title3)
        .foregroundColor(.primary)
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 0,
               maxHeight: .infinity,
               alignment: .topLeading)
        .padding(.horizontal, 25)
        .padding(.vertical, 50)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return Group {
            MenuView()
            MainView().environment(\.managedObjectContext, context)
        }
    }
}
