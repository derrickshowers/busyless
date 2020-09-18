//
//  MainView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/12/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct MainView: View {

    // MARK: - Lifecycle

    var body: some View {
        NavigationView {
            MenuView()
            DayView()
        }
    }
}

struct MenuView: View {

    // MARK: - Lifecycle

    var body: some View {
        List {
            NavigationLink(destination: DayView()) {
                Text("Today")
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
        }
        .listStyle(SidebarListStyle())
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return MainView().environment(\.managedObjectContext, context)
    }
}
