//
//  MainView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/12/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct MainView: View {

    // MARK: - Private Properties

    @State private var isDayViewActive = true
    @State private var isLogViewActive = false

    // MARK: - Lifecycle

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: DayView(), isActive: $isDayViewActive) {
                    Text("Today")
                }
                NavigationLink(destination: LogView(), isActive: $isLogViewActive) {
                    Text("Activity Log")
                }
                NavigationLink(destination: SettingsView()) {
                    HStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .onAppear {
                UITableView.appearance().separatorStyle = .none
            }
            DayView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next force_cast
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return MainView().environment(\.managedObjectContext, context)
    }
}
