//
//  AddNewActivityView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/8/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import BusylessDataLayer

struct AddNewActivityView: View {

    // MARK: - Properties

    @ObservedObject private var viewModel: AddNewActivityViewModel

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss

    // MARK: - State

    @FocusState private var activityNameFocused: Bool?

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

    private func durationStepper(with value: Binding<Int>, suffix: String) -> some View {
        Stepper("\(value.wrappedValue) \(suffix)", value: value, in: 0...23).fixedSize()
    }

    // MARK: - Initialization

    init(viewModel: AddNewActivityViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
            Form {
                Section(header: Spacer()) {
                    TextField("Activity Name", text: $viewModel.name)
                        .focused($activityNameFocused, equals: true)
                        .autocapitalization(.words)
                    NavigationLink(destination: CategorySelection(selectedCategory: $viewModel.category)) {
                        Text("Category").bold()
                        Spacer()
                        Text("\($viewModel.category.wrappedValue?.name ?? "")")
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    HStack(alignment: .top) {
                        Text("Duration").bold()
                        Spacer()
                        VStack(alignment: .trailing) {
                            durationStepper(with: $viewModel.hoursDuration, suffix: "hrs")
                            Spacer()
                            durationStepper(with: $viewModel.minutesDuration, suffix: "mins")
                        }
                    }
                    HStack {
                        Text("When?").bold()
                        Spacer()
                        DatePicker("When?", selection: $viewModel.createdAt)
                            .datePickerStyle(.compact)
                            .frame(maxWidth: 250, maxHeight: 25)
                    }

                }
                Section(header: Text("NOTES")) {
                    TextEditor(text: $viewModel.notes)
                }
            }
            .navigationBarTitleDisplayMode(.automatic)
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
            AddNewActivityView.forTesting()
            AddNewActivityView.forTesting()
                .environment(\.colorScheme, .dark)

        }
    }
}
