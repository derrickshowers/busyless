//
//  AddNewActivityView.swift
//  TimeBudget
//
//  Created by Derrick Showers on 8/8/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import os

struct AddNewActivityView: View {

    // MARK: - Public Properties

    @Binding var isPresented: Bool

    // MARK: - Private Properties

    @State private var name = ""
    @State private var category: Category?
    @State private var duration = ""
    @State private var notes = ""

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    // MARK: - Lifecycle

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
                        }
                        HStack {
                            Text("Duration (in hours)")
                            TextField(duration, text: $duration)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        }

                    }
                    Section(header: Text("NOTES")) {
                        TextView(text: $notes)
                        .frame(height: 200.0)
                    }
                }
                Button(action: {
                    self.addActivity()
                    self.isPresented = false
                }, label: {
                    HStack {
                        Spacer()
                        Text("Save")
                        Spacer()
                    }

                })
                    .frame(maxWidth: 400)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .padding(.horizontal, 20)

            }
            .navigationBarTitle("Log New Activity")
        }
    }
}

// MARK: - Core Data

extension AddNewActivityView {

    private func addActivity() {
        let activity = Activity(context: managedObjectContext)
        activity.name = name
        activity.category = category
        activity.duration = Int16(duration) ?? 0
        activity.notes = notes
        activity.createdAt = Date()
        Activity.save(with: managedObjectContext)
    }
}

struct AddNewActivityView_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next force_cast
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return AddNewActivityView(isPresented: .constant(true)).environment(\.managedObjectContext, context)
    }
}
