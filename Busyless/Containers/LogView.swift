//
//  LogView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/16/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import BusylessDataLayer

struct LogView: View {

    // MARK: - Private Properties

    @State private var isAddNewActivityViewPresented = false
    @State private var isAddNewActivityViewPresentedModally = false

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    @Environment(\.dataStore)
    private var dataStore

    private var activities: [[Activity]] {
        return dataStore?.wrappedValue.activityStore.allActivitiesGroupedByDate ?? []
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }

    // MARK: - Lifecycle

    var body: some View {
        ZStack {
            List {
                ForEach(activities, id: \.self) { (section: [Activity]) in
                    Section(header: Text(self.sectionHeader(forCreationDate: section[0].createdAt)).font(Font.headline.smallCaps())) {
                        ForEach(section, id: \.self) { (activity: Activity) in
                            NavigationLink(destination: AddNewActivityView(isPresented: self.$isAddNewActivityViewPresented,
                                                                           activity: activity,
                                                                           showNavigationBar: false)) {
                                VStack(alignment: .leading) {
                                    Text(activity.name ?? "")
                                        .font(.headline)
                                    HStack {
                                        Text(activity.category?.name ?? "Uncategorized")
                                        if let date = activity.createdAt {
                                            Text("•")
                                            Text(timeFormatter.string(from: date))
                                        }
                                        Text("•")
                                        Text(activity.duration.hoursMinutesString)
                                    }
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                }
                            }
                        }.onDelete(perform: { row in
                            if let rowIndex = row.map({$0}).first,
                                let sectionIndex = activities.firstIndex(of: section) {
                                self.deleteActivity(atRow: rowIndex, section: sectionIndex)
                            }
                        })
                    }
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddButton {
                        self.isAddNewActivityViewPresentedModally.toggle()
                    }
                }
            }
        }
        .sheet(isPresented: $isAddNewActivityViewPresentedModally) {
            AddNewActivityView(isPresented: self.$isAddNewActivityViewPresentedModally)
                .environment(\.managedObjectContext, self.managedObjectContext)
        }
        .navigationBarTitle("Activity Log")
    }

    // MARK: - Private Methods

    private func sectionHeader(forCreationDate date: Date?) -> String {
        if let date = date {
            return dateFormatter.string(from: date)
        }
        return "Unknown Date"
    }
}

// MARK: - Core Data

extension LogView {
    private func deleteActivity(atRow row: Int, section: Int) {
        let activity = self.activities[section][row]
        self.managedObjectContext.delete(activity)
        Activity.save(with: managedObjectContext)
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return LogView().environment(\.managedObjectContext, context)
    }
}
