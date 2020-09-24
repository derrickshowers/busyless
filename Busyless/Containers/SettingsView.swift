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

    @State private var isExportPresented: Bool = false

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

    private var dataExportFile: URL {
        let exportManager = ExportManager(managedObjectContext: self.managedObjectContext)
        return exportManager.createActivityExportFile()
    }

    // MARK: - Lifecycle

    var body: some View {
        Form {
            Section(header: Text("TIMES")) {
                HStack {
                    Text("Awake Time")
                    Spacer()
                    DatePicker("Awake Time", selection: awakeTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(maxWidth: 250)
                        .padding(.trailing, -15)
                }
                HStack {
                    Text("Sleepy Time")
                    Spacer()
                    DatePicker("Awake Time", selection: sleepTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(maxWidth: 250)
                        .padding(.trailing, -15)
                }
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
            Section {
                Button(action: {
                    self.isExportPresented.toggle()
                }, label: {
                    Text("Export Data to CSV")
                })
            }
        }
        .sheet(isPresented: $isExportPresented, content: {
            ActivityViewController(activityItems: [self.dataExportFile])
        })
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
        let context = PersistenceController.preview.container.viewContext
        return SettingsView().environment(\.managedObjectContext, context)
    }
}
