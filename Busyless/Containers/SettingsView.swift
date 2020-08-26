//
//  SettingsView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/12/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct SettingsView: View {

    // MARK: - Constants

    static let awakeHourDefault: Int = 7
    static let awakeDurationDefault: TimeInterval = 8

    // MARK: - Private Properties

    @State private var awakeTime = Date.today(withHour: awakeHourDefault)
    @State private var sleepTime = Date.today(withHour: awakeHourDefault + Int(awakeDurationDefault))

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    @FetchRequest(fetchRequest: UserConfig.allUserConfigsFetchRequest)
    private var userConfigs: FetchedResults<UserConfig>

    // MARK: - Lifecycle

    var body: some View {
        Form {
            Section(header: Text("TIMES")) {
                DatePicker("Awake Time",
                           selection: $awakeTime,
                           displayedComponents: .hourAndMinute)
                DatePicker("Sleepy Time",
                           selection: $sleepTime,
                           displayedComponents: .hourAndMinute)
            }
        }
        .onAppear {
            guard let userConfig = self.userConfigs.first,
                let awakeTime = userConfig.awakeTime,
                let sleepTime = userConfig.sleepTime else {
                    return
            }
            self.awakeTime = awakeTime
            self.sleepTime = sleepTime
        }
        .onDisappear {
            let userConfig = self.userConfigs.first ?? UserConfig(context: self.managedObjectContext)
            userConfig.awakeTime = self.awakeTime
            userConfig.sleepTime = self.sleepTime
            UserConfig.save(with: self.managedObjectContext)
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
