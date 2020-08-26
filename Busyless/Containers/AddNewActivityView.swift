//
//  AddNewActivityView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/8/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import os

struct AddNewActivityView: View {

    // MARK: - Public Properties

    @Binding var isPresented: Bool
    let activity: Activity?
    let showNavigationBar: Bool

    // MARK: - Private Properties

    @State private var name: String
    @State private var category: Category?
    @State private var duration: String
    @State private var notes: String

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    private var readyToSave: Bool {
        return !name.isEmpty && !duration.isEmpty
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
        _duration = State(initialValue: activity?.duration.hoursString ?? "")
        _notes = State(initialValue: activity?.notes ?? "")
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Activity Name", text: $name)
                        NavigationLink(destination: CategorySelection(selectedCategory: $category)) {
                            Text("Category")
                            Spacer()
                            Text("\(category?.name ?? "")")
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                        HStack {
                            Text("Duration (in hours)")
                            TextField(duration, text: $duration)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                        }

                    }
                    Section(header: Text("NOTES")) {
                        TextView(text: $notes)
                            .frame(height: 200.0)
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
                    self.isPresented = false
                }, label: {
                    Text("Done")
                }).disabled(!readyToSave))
        }.onDisappear {
            // We only want to force a save on disappear if done button is not available.
            // This is for the case of LogView where we hide the navigation bar.
            if !self.showNavigationBar {
                self.addActivity()
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Core Data

extension AddNewActivityView {

    private func addActivity() {
        let activity = self.activity ?? Activity(context: managedObjectContext)
        activity.name = name
        activity.category = category
        activity.duration = (TimeInterval(duration) ?? 0) * TimeInterval.oneHour
        activity.notes = notes
        activity.createdAt = self.activity?.createdAt ?? Date()
        Activity.save(with: managedObjectContext)
    }
}

struct AddNewActivityView_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next force_cast
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let activity = Activity.mockActivity
        return Group {
            AddNewActivityView(isPresented: .constant(true))
            AddNewActivityView(isPresented: .constant(true), activity: activity)
                .environment(\.colorScheme, .dark)

        }.environment(\.managedObjectContext, context)
    }
}
