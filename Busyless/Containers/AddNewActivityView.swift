//
//  AddNewActivityView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/8/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import Intents
import os

struct AddNewActivityView: View {

    // MARK: - Public Properties

    @Binding var isPresented: Bool
    let activity: Activity?
    let showNavigationBar: Bool

    // MARK: - Private Properties

    @State private var name: String
    @State private var category: Category?
    @State private var hoursDuration: Int
    @State private var minutesDuration: Int
    @State private var createdAt: Date
    @State private var notes: String

    @State private var showAdvancedSection = false

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    private var readyToSave: Bool {
        return !name.isEmpty && (hoursDuration != 0 || minutesDuration != 0)
    }

    // MARK: - Lifecycle

    init(isPresented: Binding<Bool>,
         activity: Activity? = nil,
         preselectedCategory: Category? = nil,
         showNavigationBar: Bool = true) {
        self._isPresented = isPresented
        self.activity = activity
        self.showNavigationBar = showNavigationBar
        _name = State(initialValue: activity?.name ?? "")
        _category = State(initialValue: activity?.category ?? preselectedCategory)
        _createdAt = State(initialValue: activity?.createdAt ?? Date())
        _notes = State(initialValue: activity?.notes ?? "")

        let calculatedDuration = activity?.duration.asHoursAndMinutes
        _hoursDuration = State(initialValue: calculatedDuration?.hours ?? 0)
        _minutesDuration = State(initialValue: calculatedDuration?.minutes ?? 0)
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Activity Name", text: $name)
                            .autocapitalization(.words)
                        NavigationLink(destination: CategorySelection(selectedCategory: $category)) {
                            Text("Category")
                            Spacer()
                            Text("\(category?.name ?? "")")
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                        HStack {
                            Text("Duration")
                            Spacer()
                            Picker("\(hoursDuration) hours", selection: $hoursDuration, content: {
                                ForEach(0..<6, id: \.self) { hours in
                                    Text("\(hours) hours").tag(hours)
                                }
                            }).pickerStyle(MenuPickerStyle())
                            Picker("\(minutesDuration) Minutes", selection: $minutesDuration, content: {
                                Text("0 minutes").tag(0)
                                Text("15 minutes").tag(15)
                                Text("30 minutes").tag(30)
                                Text("45 minutes").tag(45)
                            }).pickerStyle(MenuPickerStyle())
                        }
                        HStack {
                            Text("When?")
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
            .navigationBarTitle("Log New Activity")
            .navigationBarHidden(!showNavigationBar)
            .navigationBarItems(leading:
                Button(action: {
                    self.isPresented = false
                }, label: {
                    Text("Cancel")
                }), trailing:
                Button(action: {
                    self.addActivity()
                    self.donateAddNewActivityIntent()
                    self.isPresented = false
                }, label: {
                    Text("Done")
                }).disabled(!readyToSave))
        }.onDisappear {
            // We only want to force a save on disappear if done button is not available.
            // This is for the case of LogView where we hide the navigation bar.
            if !self.showNavigationBar {
                self.addActivity()
                self.donateAddNewActivityIntent()
            }
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
