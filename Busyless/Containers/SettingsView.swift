//
//  SettingsView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/12/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct SettingsView: View {

    // MARK: - Private Properties

    @State private var wakeUpTime = SettingsView.wakeUpTime

    @State private var sleepyTime = SettingsView.sleepyTime

    @UserDefault("wakeup_time", defaultValue: Date.today(withHour: 7))
    static var wakeUpTime: Date

    @UserDefault("sleepy_time", defaultValue: Date.today(withHour: 23))
    static var sleepyTime: Date

    // MARK: - Lifecycle

    var body: some View {
        Form {
            Section(header: Text("TIMES")) {
                DatePicker("Awake Time",
                           selection: $wakeUpTime,
                           displayedComponents: .hourAndMinute)
                DatePicker("Sleepy Time",
                           selection: $sleepyTime,
                           displayedComponents: .hourAndMinute)
            }
        }
        .onDisappear {
            SettingsView.wakeUpTime = self.wakeUpTime
            SettingsView.sleepyTime = self.sleepyTime
        }
        .navigationBarTitle("Settings")
    }
}

private extension Date {
    static func today(withHour hour: Int) -> Date {
        var components = DateComponents()
        components.hour = hour
        return Calendar.current.date(from: components) ?? Date()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
