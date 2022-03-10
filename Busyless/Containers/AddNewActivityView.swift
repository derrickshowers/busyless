//
//  AddNewActivityView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/8/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import BusylessDataLayer
import SwiftUI

struct AddNewActivityView: View {
    // MARK: - Properties

    @ObservedObject private var viewModel: AddNewActivityViewModel

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss

    // MARK: - State

    @FocusState private var activityNameFocused: Bool

    // MARK: - Views

    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
    }

    private var doneButton: some View {
        Button("Done") {
            viewModel.save()
            dismiss()
        }.disabled(!viewModel.readyToSave)
    }

    private func identifierIcon(systemName: String) -> some View {
        Image(systemName: systemName)
            .foregroundColor(.white)
            .padding(5)
            .background(Color.mainColor)
            .cornerRadius(10)
    }

    private func durationStepper(with value: Binding<Int>, suffix: String) -> some View {
        Stepper("\(value.wrappedValue) \(suffix)", value: value, in: 0 ... 23).fixedSize()
    }

    // MARK: - Initialization

    init(viewModel: AddNewActivityViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Lifecycle

    var body: some View {
        VStack {
            Form {
                Section(
                    header: TextField("Activity Name", text: $viewModel.name)
                        .focused($activityNameFocused, equals: true)
                        .submitLabel(.done)
                        .autocapitalization(.words)
                        .font(.title)
                        .textCase(.none)
                        .padding(.bottom, 10)
                        .foregroundColor(Color.mainColor)
                ) {
                    NavigationLink(destination: CategorySelection(selectedCategory: $viewModel.category)) {
                        identifierIcon(systemName: "folder")
                        Text("Category")
                        Spacer()
                        Text("\($viewModel.category.wrappedValue?.name ?? "")")
                            .lineLimit(1)
                    }
                }

                Section {
                    HStack {
                        identifierIcon(systemName: "clock.arrow.circlepath")
                        Text("Duration")
                        Spacer()
                        VStack(alignment: .trailing) {
                            durationStepper(with: $viewModel.hoursDuration, suffix: "hrs")
                            Spacer()
                            durationStepper(with: $viewModel.minutesDuration, suffix: "mins")
                        }
                    }
                }

                Section {
                    HStack {
                        identifierIcon(systemName: "calendar")
                        DatePicker(
                            "Date",
                            selection: $viewModel.createdAt,
                            displayedComponents: .date
                        )
                    }
                    HStack {
                        identifierIcon(systemName: "clock")
                        DatePicker(
                            "Time",
                            selection: $viewModel.createdAt,
                            displayedComponents: .hourAndMinute
                        )
                    }
                }

                Section(header: Text("NOTES")) {
                    TextEditor(text: $viewModel.notes)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Log New Activity")
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                activityNameFocused = $viewModel.name.wrappedValue.isEmpty
            }
        }
        .navigationBarItems(leading: cancelButton, trailing: doneButton)
    }
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
            // Wrapped in a ZStack to fix previews bug
            // See here: https://www.hackingwithswift.com/forums/swiftui/focusstate-breaking-preview/11396
            ZStack {
                AddNewActivityView.forTesting()
            }
            ZStack {
                AddNewActivityView.forTesting()
                    .environment(\.colorScheme, .dark)
            }
        }
    }
}
