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

    // MARK: - Public Properties

    @Binding var isPresented: Bool
    let activity: Activity?

    // MARK: - Private Properties

    @State private var name: String
    @State private var category: BLCategory?
    @State private var hoursDuration: Int
    @State private var minutesDuration: Int
    @State private var createdAt: Date
    @State private var notes: String

    @State private var showAdvancedSection = false
    @State private var isActivityNameFirstResponder: Bool

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    private var isEditingExistingActivity: Bool

    private var readyToSave: Bool {
        return !name.isEmpty && (hoursDuration != 0 || minutesDuration != 0)
    }

    // MARK: - Lifecycle

    init(isPresented: Binding<Bool>,
         activity: Activity? = nil,
         preselectedCategory: BLCategory? = nil) {
        self._isPresented = isPresented
        self.activity = activity
        self.isEditingExistingActivity = activity != nil
        _name = State(initialValue: activity?.name ?? "")
        _category = State(initialValue: activity?.category ?? preselectedCategory)
        _createdAt = State(initialValue: activity?.createdAt ?? Date())
        _notes = State(initialValue: activity?.notes ?? "")

        let calculatedDuration = activity?.duration.asHoursAndMinutes
        _hoursDuration = State(initialValue: calculatedDuration?.hours ?? 0)
        _minutesDuration = State(initialValue: calculatedDuration?.minutes ?? 30)

        _isActivityNameFirstResponder = State(initialValue: activity == nil)
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        FirstResponderTextField("Activity Name", text: $name, isFirstResponder: $isActivityNameFirstResponder)
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
                            DatePicker("When?", selection: $createdAt, displayedComponents: .hourAndMinute)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .frame(maxWidth: 250)
                                .padding(.trailing, -15)
                        }

                    }
                    Section(header: Text("NOTES")) {
                        TextEditor(text: $notes)
                    }
                    if !showAdvancedSection {
                        Button("Show Advanced Options") {
                            showAdvancedSection = true
                        }
                    } else {
                        HStack {
                            DatePicker("Date", selection: $createdAt, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                        }
                    }
                }
            }
            .navigationBarTitle(isEditingExistingActivity ? "Edit Activity" : "Log New Activity")
            .navigationBarItems(leading:
                Button(action: {
                    self.isActivityNameFirstResponder = false
                    self.isPresented = false
                }, label: {
                    Text("Cancel")
                }), trailing:
                Button(action: {
                    self.addActivity()
                    self.donateAddNewActivityIntent()
                    self.isActivityNameFirstResponder = false
                    self.isPresented = false
                }, label: {
                    Text("Done")
                }).disabled(!readyToSave))
        }.navigationViewStyle(StackNavigationViewStyle())
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

    private func addActivity() {
        let activity = self.activity ?? Activity(context: managedObjectContext)
        activity.name = name
        activity.category = category
        activity.duration = TimeInterval.calculateTotalDurationFrom(hours: hoursDuration, minutes: minutesDuration)
        activity.notes = notes
        activity.createdAt = createdAt
        Activity.save(with: managedObjectContext)
    }
}

struct AddNewActivityView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let activity = Activity.mockActivity()
        return Group {
            AddNewActivityView(isPresented: .constant(true))
            AddNewActivityView(isPresented: .constant(true), activity: activity)
                .environment(\.colorScheme, .dark)

        }.environment(\.managedObjectContext, context)
    }
}
