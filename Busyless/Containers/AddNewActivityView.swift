//
//  AddNewActivityView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/8/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import Intents
import BusylessDataLayer
import os

struct AddNewActivityView: View {

    // MARK: - Properties

    @ObservedObject private var viewModel: AddNewActivityViewModel

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss

    // MARK: - State

    @State private var name: String
    @State private var category: BLCategory?
    @State private var hoursDuration: Int
    @State private var minutesDuration: Int
    @State private var createdAt: Date
    @State private var notes: String

    @FocusState private var activityNameFocused: Bool?

    private var isEditingExistingActivity: Bool = false

    private var readyToSave: Bool {
        return !name.isEmpty && (hoursDuration != 0 || minutesDuration != 0)
    }

    // MARK: - Initialization

    init(viewModel: AddNewActivityViewModel) {
        self.viewModel = viewModel

        let calculatedDuration = viewModel.activity.duration.asHoursAndMinutes
        _name = State(initialValue: viewModel.activity.name ?? "")
        _category = State(initialValue: viewModel.activity.category)
        _createdAt = State(initialValue: viewModel.activity.createdAt ?? Date())
        _notes = State(initialValue: viewModel.activity.notes ?? "")
        _hoursDuration = State(initialValue: calculatedDuration.hours)
        _minutesDuration = State(initialValue: calculatedDuration.minutes)
    }

    var body: some View {
            Form {
                Section(header: Spacer()) {
                    TextField("Activity Name", text: $name)
                        .focused($activityNameFocused, equals: true)
                        .autocapitalization(.words)
                    NavigationLink(destination: CategorySelection(selectedCategory: $category)) {
                        Text("Category").bold()
                        Spacer()
                        Text("\(category?.name ?? "")")
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    HStack(alignment: .top) {
                        Text("Duration").bold()
                        Spacer()
                        VStack(alignment: .trailing) {
                            Stepper("\(hoursDuration) hrs", value: $hoursDuration, in: 0...23).fixedSize()
                            Spacer()
                            Stepper("\(minutesDuration) mins", value: $minutesDuration, in: 0...45, step: 15).fixedSize()
                        }
                    }
                    HStack {
                        Text("When?").bold()
                        Spacer()
                        DatePicker("When?", selection: $createdAt)
                            .datePickerStyle(.compact)
                            .frame(maxWidth: 250, maxHeight: 25)
                    }

                }
                Section(header: Text("NOTES")) {
                    TextEditor(text: $notes)
                }
            }
            .navigationBarTitleDisplayMode(.automatic)
            .navigationBarTitle(isEditingExistingActivity ? "Edit Activity" : "Log New Activity")
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    activityNameFocused = name.isEmpty
                }
            }
            .navigationBarItems(leading:
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancel")
                }), trailing:
                Button(action: {
                    //self.addActivity()
                    self.donateAddNewActivityIntent()
                    //onComplete()
                }, label: {
                    Text("Done")
                }).disabled(!readyToSave))

    }

    // MARK: - Private Methods

    private func donateAddNewActivityIntent() {
        let intent = AddNewActivityIntent()
        intent.name = self.name
        let totalDuration = TimeInterval.calculateTotalDurationFrom(hours: hoursDuration, minutes: minutesDuration)
        intent.durationInMinutes = NSNumber(value: (totalDuration / TimeInterval.oneHour) * TimeInterval.oneMinute)
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate(completion: nil)
    }
}

// MARK: - Core Data

extension AddNewActivityView {

    // TODO: Move to view model
//    private func addActivity() {
//        let activity = self.activity ?? Activity(context: managedObjectContext)
//        activity.name = name
//        activity.category = category
//        activity.duration = TimeInterval.calculateTotalDurationFrom(hours: hoursDuration, minutes: minutesDuration)
//        activity.notes = notes
//        activity.createdAt = createdAt
//        Activity.save(with: managedObjectContext)
//    }
}

extension AddNewActivityView {
    static func forTesting() -> AddNewActivityView {
        let mockDataStore = DataStore(managedObjectContext: PersistenceController.preview.container.viewContext)
        let mockViewModel = AddNewActivityViewModel(dataStore: mockDataStore)
        return Self(viewModel: mockViewModel)
    }
}

struct AddNewActivityView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            AddNewActivityView.forTesting()
            AddNewActivityView.forTesting()
                .environment(\.colorScheme, .dark)

        }
    }
}
