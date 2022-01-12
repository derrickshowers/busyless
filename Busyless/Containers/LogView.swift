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

    // MARK: - Properties

    @State var isAddNewActivityViewPresented = false
    @State var showOnlyUncategorizedActivities = false
    @State var isOnboardingPresented = false
    
    @State private var selections = Set<Activity>()
    @State private var editMode: EditMode = .inactive

    /**
     This is somewhat of a hack. This property should be a state variable and then passed as an param when creating `AddNewActivityView` but
     for some weird reason, the value is never correct the first time (`nil` on breakpoint in `AddNewActivityView` initializer). Tried everything to
     get around this (resetting value, only presenting on `didSet` of `selectedActivity`).
     Note: needs to be static because instance variable cannot be modified from body on struct.
     */
    static private var selectedActivity: Activity?

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    @Environment(\.dataStore)
    private var dataStore

    @AppStorage("shouldShowLogOnboarding")
    private var shouldShowLogOnboarding = true

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
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .medium
        return formatter
    }

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }

    // MARK: - Testing

    var didAppear: ((Self) -> Void)?

    // MARK: - Lifecycle

    var body: some View {
        NavigationView {
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
                            showOnlyUncategorizedActivities.toggle()
                        })
                    }
                    List(selection: $selections) {
                        ForEach(activities, id: \.self) { (section: [Activity]) in
                            Section {
                                ForEach(section, id: \.self) { (activity: Activity) in
                                    if !showOnlyUncategorizedActivities || (showOnlyUncategorizedActivities && activity.category == nil) {
                                        ActivityRow(activity: activity) {
                                            LogView.selectedActivity = activity
                                            isAddNewActivityViewPresented.toggle()
                                        }
                                        // TODO: Extract this to make things cleaner, but how??
                                        .contextMenu {
                                            Button("Delete") {
                                                deleteActivity(activity)
                                            }
                                            Button("Edit Multiple...") {
                                                editMode = .active
                                            }
                                        }
                                    }
                                }
                            } header: {
                                Text(self.sectionHeader(forCreationDate: section[0].createdAt))
                                    .foregroundColor(Color.primary)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .environment(\.editMode, $editMode)
                    .listStyle(.grouped)
                    if editMode == .active {
                        ActionBar(onDelete: {
                            // TODO: This causes a crash
                            selections.forEach { deleteActivity($0) }
                            editMode = .inactive
                        }, onCancel: {
                            editMode = .inactive
                        })
                    }
                }.sheet(isPresented: $isOnboardingPresented) {
                    LogOnboardingView()
                }.sheet(isPresented: $isAddNewActivityViewPresented) {
                    AddNewActivityView(activity: LogView.selectedActivity) {
                        isAddNewActivityViewPresented = false
                    }.environment(\.managedObjectContext, managedObjectContext)
                }
            }
            .onAppear {
                self.didAppear?(self)
                // TODO: Cleanup onboarding and re-add
                // showOnboardingIfNeeded()
            }
            .navigationBarTitle("Activity Log")
        }
    }

    // MARK: - Private Methods

    private func sectionHeader(forCreationDate date: Date?) -> String {
        if let date = date {
            return dateFormatter.string(from: date)
        }
        return "Unknown Date"
    }

    private func showOnboardingIfNeeded() {
        guard shouldShowLogOnboarding else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isOnboardingPresented = true
            shouldShowLogOnboarding = false
        }
    }
}

struct ActivityRow: View {
    let activity: Activity
    let action: () -> Void
    
    // TODO: Share this
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        Button(action: { action() }, label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(activity.name ?? "")
                        .foregroundColor(Color.primary)
                        .font(.subheadline)
                    Text(activity.category?.name ?? "Uncategorized")
                        .font(.caption2)
                        .foregroundColor(Color.gray)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(activity.duration.hoursMinutesString)
                        .foregroundColor(Color.primary)
                        .font(.subheadline)
                    if let date = activity.createdAt {
                        Text(timeFormatter.string(from: date))
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
        }).padding(.vertical, 5)
    }
}

struct ActionBar: View {
    let onDelete: () -> Void
    let onCancel: () -> Void
    var body: some View {
        HStack {
            Button {
                onDelete()
            } label: {
                Text("Delete")
            }
            Button {
                onCancel()
            } label: {
                Text("Cancel")
            }
            Spacer()
        }
    }
}

// MARK: - Core Data

extension LogView {
    private func deleteActivity(atRow row: Int, section: Int) {
        let activity = activities[section][row]
        managedObjectContext.delete(activity)
        Activity.save(with: managedObjectContext)
    }
    
    private func deleteActivity(_ activity: Activity) {
        managedObjectContext.delete(activity)
        Activity.save(with: managedObjectContext)
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let dataStore = ObservedObject(initialValue: DataStore(managedObjectContext: context))
        let logView = LogView()
            .environment(\.managedObjectContext, context)
            .environment(\.dataStore, dataStore)
        return Group {
            logView
            logView.environment(\.colorScheme, .dark)
        }
    }
}
