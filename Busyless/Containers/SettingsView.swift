//
//  SettingsView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/12/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import os

struct SettingsView: View {

    // MARK: - Constants

    static let awakeHourDefault: Int = 7
    static let awakeDurationDefault: TimeInterval = 16 * TimeInterval.oneHour
    static let defaultAwakeTime = Date.today(withHour: awakeHourDefault)
    static let defaultSleepTime = Date.today(withHour: awakeHourDefault + Int(awakeDurationDefault / TimeInterval.oneHour))

    // MARK: - Private Properties

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    @FetchRequest(fetchRequest: UserConfig.allUserConfigsFetchRequest)
    private var userConfigs: FetchedResults<UserConfig>

    private var iCloudStatusColor: Color {
        if FileManager.default.ubiquityIdentityToken != nil {
            return Color.green
        } else {
            return Color.red
        }
    }

    private var awakeTime: Binding<Date> {
        return Binding<Date>(
            get: { self.userConfigs.first?.awakeTime ?? SettingsView.defaultAwakeTime },
            set: { self.userConfigs.first?.awakeTime = $0 }
        )
    }

    private var sleepTime: Binding<Date> {
        return Binding<Date>(
            get: { self.userConfigs.first?.sleepTime ?? SettingsView.defaultSleepTime },
            set: { self.userConfigs.first?.sleepTime = $0 }
        )
    }

    // MARK: - Lifecycle

    var body: some View {
        Form {
            Section(header: Text("TIMES")) {
                DatePicker("Awake Time", selection: awakeTime, displayedComponents: .hourAndMinute)
                DatePicker("Sleepy Time", selection: sleepTime, displayedComponents: .hourAndMinute)
            }
            Section {
                HStack {
                    Text("iCloud Status")
                    Spacer()
                    Circle()
                    .foregroundColor(iCloudStatusColor)
                        .fixedSize(horizontal: true, vertical: true)

                }
            }
        }
        .onAppear {
            self.setupUserConfigIfNewUser()
        }
        .onDisappear {
            UserConfig.save(with: self.managedObjectContext)
        }
        .navigationBarTitle("Settings")
    }

    // MARK: - Private Methods

    private func setupUserConfigIfNewUser() {
        if self.userConfigs.count == 0 {
            _ = UserConfig(context: self.managedObjectContext)
        } else if self.userConfigs.count > 1 {
            os_log("There are more UserConfig objects than there should be.")
        }
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
        // swiftlint:disable:next force_cast
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return SettingsView().environment(\.managedObjectContext, context)
    }
}
