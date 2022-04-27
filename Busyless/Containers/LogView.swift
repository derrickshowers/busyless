//
//  LogView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/16/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import BusylessDataLayer
import SwiftUI

struct LogView: View {
    // MARK: - Properties

    @ObservedObject private var viewModel: LogViewModel

    // MARK: State

    @State private var isAddNewActivityViewPresented = false
    @State private var isCategorySelectionViewPresented = false
    @State private var showOnlyUncategorizedActivities = false
    @State private var isOnboardingPresented = false

    @State private var selections = Set<Activity>()
    @State private var editMode: EditMode = .inactive

    // MARK: - Initialization

    init(viewModel: LogViewModel) {
        self.viewModel = viewModel
        UIRefreshControl.appearance().tintColor = UIColor.white
    }

    // MARK: - Views

    @ViewBuilder
    private func actionsContextMenu(for activity: Activity) -> some View {
        Button("Delete") {
            viewModel.deleteActivity(activity)
        }
        Button("Duplicate") {
            viewModel.duplicateActivity(activity)
        }
        Button("Copy Activity Name") {
            viewModel.copyName(activity)
        }
        Button("Edit Category") {
            selections.removeAll()
            selections.insert(activity)
            isCategorySelectionViewPresented.toggle()
        }
        Button("Duration") {}
            .contextMenu {
                Button("15 mins") { viewModel.set(durationInHours: 0.25, for: activity) }
                Button("30 mins") { viewModel.set(durationInHours: 0.5, for: activity) }
                Button("1 hour") { viewModel.set(durationInHours: 1.0, for: activity) }
            }
        Button("Round Up/Down Time") {
            viewModel.roundTime(activity)
        }
        Button("Edit Multiple...") {
            selections.removeAll()
            selections.insert(activity)
            editMode = .active
        }
    }

    private var uncategorizedBanner: some View {
        HStack {
            Text(
                showOnlyUncategorizedActivities ? "Viewing uncategorized activities." :
                    "You have uncategorized activities."
            )
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

    // MARK: - Lifecycle

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    if viewModel.containsUncategorizedActivities || showOnlyUncategorizedActivities {
                        uncategorizedBanner
                    }

                    List(selection: $selections) {
                        ForEach(viewModel.activities, id: \.self) { (section: [Activity]) in
                            Section {
                                ForEach(section, id: \.self) { (activity: Activity) in
                                    if !showOnlyUncategorizedActivities ||
                                        (showOnlyUncategorizedActivities && activity.category == nil) {
                                        ActivityRow(
                                            activity: activity,
                                            isEditing: editMode.isEditing
                                        ) {
                                            selections.insert(activity)
                                            isAddNewActivityViewPresented.toggle()
                                        }.contextMenu { self.actionsContextMenu(for: activity) }
                                    }
                                }
                                .listRowInsets(EdgeInsets())
                            } header: {
                                Text(viewModel.sectionHeader(for: section))
                                    .foregroundColor(Color.primary)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .refreshable {
                        let duration = UInt64(1 * 1_000_000_000) // one second
                        try? await Task.sleep(nanoseconds: duration)
                        viewModel.refresh()
                    }
                    .environment(\.editMode, $editMode)
                    .listStyle(.grouped)

                    if editMode == .active {
                        ActionBar(onDelete: {
                            selections.forEach { viewModel.deleteActivity($0) }
                            editMode = .inactive
                        }, onEditCategory: {
                            isCategorySelectionViewPresented.toggle()
                            editMode = .inactive
                        }, onRoundTime: {
                            selections.forEach { viewModel.roundTime($0) }
                            editMode = .inactive
                        }, onCancel: {
                            editMode = .inactive
                        }).padding(.bottom, 10)
                    }
                }.sheet(isPresented: $isOnboardingPresented) {
                    LogOnboardingView()
                }.sheet(isPresented: $isAddNewActivityViewPresented, onDismiss: {
                    selections.removeAll()
                }, content: {
                    if let activity = selections.first {
                        NavigationView {
                            viewModel.viewForAddActivityActivity(activity)
                        }
                    }
                }).sheet(isPresented: $isCategorySelectionViewPresented, onDismiss: {
                    selections.removeAll()
                }, content: {
                    if let category = viewModel.newCategory(for: selections) {
                        NavigationView {
                            CategorySelection(selectedCategory: category)
                        }
                    }
                })
            }
            .onAppear {
                self.didAppear?(self)
                // TODO: Cleanup onboarding and re-add
                // showOnboardingIfNeeded()
            }
            .navigationBarTitle("Activity Log")
        }
    }

    // MARK: - Testing

    var didAppear: ((Self) -> Void)?
}

// MARK: - Onboarding

extension LogView {
    private func showOnboardingIfNeeded() {
        guard viewModel.shouldShowLogOnboarding else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isOnboardingPresented = true
            viewModel.shouldShowLogOnboarding = false
        }
    }
}

// MARK: - Testing/Previews

extension LogView {
    static func forTesting() -> LogView {
        let mockDataStore = DataStore(managedObjectContext: PersistenceController.preview.container.viewContext)
        let mockViewModel = LogViewModel(dataStore: mockDataStore) { _ in AddNewActivityView.forTesting() }
        return Self(viewModel: mockViewModel)
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        let logView = LogView.forTesting()
        return Group {
            logView
            logView.environment(\.colorScheme, .dark)
        }
    }
}
