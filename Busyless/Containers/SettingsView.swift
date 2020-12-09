//
//  SettingsView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/12/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import BusylessDataLayer
import os

struct SettingsView: View {

    // MARK: - Private Properties

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    @Environment(\.dataStore)
    private var dataStore

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
            get: { dataStore?.wrappedValue.userConfigStore.awakeTime ?? UserConfigStore.defaultAwakeTime },
            set: { dataStore?.wrappedValue.userConfigStore.awakeTime = $0 }
        )
    }

    private var sleepTime: Binding<Date> {
        return Binding<Date>(
            get: { dataStore?.wrappedValue.userConfigStore.sleepTime ?? UserConfigStore.defaultAwakeTime },
            set: { dataStore?.wrappedValue.userConfigStore.sleepTime = $0 }
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
                Link(destination: URL(string: "https://www.icloud.com/shortcuts/f2f66a8c23de4ec085771cd80fb1f512")!, label: {
                    Text("Add a Focus Shortcut")
                })
            }
        }
        .sheet(isPresented: $isExportPresented, content: {
            ActivityViewController(activityItems: [self.dataExportFile])
        })
        .onDisappear {
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
        let context = PersistenceController.preview.container.viewContext
        return SettingsView().environment(\.managedObjectContext, context)
    }
}
