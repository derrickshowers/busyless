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
    @State private var showOnlyUncategorizedActivities = false

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    @Environment(\.dataStore)
    private var dataStore

    private var activities: [[Activity]] {
        return dataStore?.wrappedValue.activityStore.allActivitiesGroupedByDate ?? []
    }

    private var containsUncategorizedActivities: Bool {
        let uncategorizedActivityCount = activities.flatMap({ $0 }).reduce(0) {
            $0 + ($1.category == nil ? 1 : 0)
        }
        return uncategorizedActivityCount > 0
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
            VStack(spacing: 0) {
                if containsUncategorizedActivities || showOnlyUncategorizedActivities {
                    HStack {
                        Text(showOnlyUncategorizedActivities ? "Viewing uncategorized activities." : "You have uncategorized activities.")
                            .font(Font.callout).bold()
                        Spacer()
                        Text(showOnlyUncategorizedActivities ? "see all" : "tap to view")
                            .font(Font.caption).bold()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.secondaryColor)
                    .foregroundColor(Color.white)
                    .onTapGesture(perform: {
                        self.showOnlyUncategorizedActivities.toggle()
                    })
                }
                List {
                    ForEach(activities, id: \.self) { (section: [Activity]) in
                        Section(header: Text(self.sectionHeader(forCreationDate: section[0].createdAt)).font(Font.headline.smallCaps())) {
                            ForEach(section, id: \.self) { (activity: Activity) in
                                if !showOnlyUncategorizedActivities || (showOnlyUncategorizedActivities && activity.category == nil) {
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
        let dataStore = ObservedObject(initialValue: DataStore(managedObjectContext: context))
        return LogView()
            .environment(\.managedObjectContext, context)
            .environment(\.dataStore, dataStore)
    }
}
