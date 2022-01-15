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

    @ObservedObject private var viewModel: LogViewModel

    // MARK: State

    @State var isAddNewActivityViewPresented = false
    @State var isCategorySelectionViewPresented = false
    @State var showOnlyUncategorizedActivities = false
    @State var isOnboardingPresented = false

    @State private var selections = Set<Activity>()
    @State private var editMode: EditMode = .inactive

    init(viewModel: LogViewModel) {
        self.viewModel = viewModel
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
        Button("Edit Category") {
            selections.insert(activity)
            isCategorySelectionViewPresented.toggle()
        }
        Button("Edit Multiple...") {
            selections.removeAll()
            editMode = .active
        }
    }

    private var uncategorizedBanner: some View {
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
                                    if !showOnlyUncategorizedActivities || (showOnlyUncategorizedActivities && activity.category == nil) {
                                        ActivityRow(activity: activity) {
                                            selections.insert(activity)
                                            isAddNewActivityViewPresented.toggle()
                                        }.contextMenu { self.actionsContextMenu(for: activity) }
                                    }
                                }
                            } header: {
                                Text(viewModel.sectionHeader(for: section))
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
                            selections.forEach { viewModel.deleteActivity($0) }
                            editMode = .inactive
                        }, onEditCategory: {
                            isCategorySelectionViewPresented.toggle()
                            editMode = .inactive
                        }, onCancel: {
                            editMode = .inactive
                        })
                    }
                }.sheet(isPresented: $isOnboardingPresented) {
                    LogOnboardingView()
                }.sheet(isPresented: $isAddNewActivityViewPresented) {
                    AddNewActivityView(activity: selections.first) {
                        selections.removeAll()
                        isAddNewActivityViewPresented = false
                    }
                }.sheet(isPresented: $isCategorySelectionViewPresented) {
                    if let category = viewModel.newCategory(for: selections) {
                        CategorySelection(selectedCategory: category)
                    }
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
        let mockViewModel = LogViewModel(dataStore: mockDataStore)
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
