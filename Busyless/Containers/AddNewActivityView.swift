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
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - State

    @FocusState private var activityNameFocused: Bool

    // MARK: - Views

    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }.foregroundColor(.white)
    }

    private var doneButton: some View {
        Button("Done") {
            viewModel.save()
            dismiss()
        }
        .disabled(!viewModel.readyToSave)
        .foregroundColor(viewModel.readyToSave ? .white : .white.opacity(0.2))
    }

    private var activityNameTextField: some View {
        TextField("Activity Name", text: $viewModel.name)
            .focused($activityNameFocused, equals: true)
            .submitLabel(.done)
            .autocapitalization(.words)
            .font(.title)
            .textCase(.none)
            .padding(.bottom, 10)
            .foregroundColor(colorScheme == .light ? Color.mainColor : Color.secondaryColor)
    }

    private func datePicker(for component: DatePickerComponents) -> some View {
        DatePicker(
            component == .date ? "Date" : "Time",
            selection: $viewModel.createdAt,
            displayedComponents: component
        )
    }

    private func identifierIcon(systemName: String) -> some View {
        Image(systemName: systemName)
            .foregroundColor(colorScheme == .light ? .white : .black)
            .padding(5)
            .background(colorScheme == .light ? Color.mainColor : Color.secondaryColor)
            .cornerRadius(10)
    }

    private func durationStepper(
        with value: Binding<Int>,
        suffix: String,
        step: Int.Stride,
        range: ClosedRange<Int>
    ) -> some View {
        Stepper("\(value.wrappedValue) \(suffix)", value: value, in: range, step: step).fixedSize()
    }

    // MARK: - Initialization

    init(viewModel: AddNewActivityViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Lifecycle

    var body: some View {
        VStack {
            Form {
                Section(header: activityNameTextField) {
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
                            durationStepper(
                                with: $viewModel.hoursDuration,
                                suffix: "hrs",
                                step: 1,
                                range: 0 ... 23
                            )
                            Spacer()
                            durationStepper(
                                with: $viewModel.minutesDuration,
                                suffix: "mins",
                                step: 15,
                                range: 0 ... 45
                            )
                        }
                    }
                }

                Section {
                    HStack {
                        identifierIcon(systemName: "calendar")
                        datePicker(for: .date)
                    }
                    HStack {
                        identifierIcon(systemName: "clock")
                        datePicker(for: .hourAndMinute)
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
