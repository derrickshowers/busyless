//
//  CategorySelection.swift
//  Busyless
//
//  Created by Derrick Showers on 8/16/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import BusylessDataLayer

struct CategorySelection: View {

    // MARK: - Public Properties

    @Binding var selectedCategory: BLCategory?

    // MARK: - Private Properties

    @Environment(\.presentationMode)
    private var presentationMode: Binding<PresentationMode>

    @Environment(\.dataStore)
    private var dataStore

    @State private var isAddNewCategorySheetShowing = false
    @State private var newCategory: String = ""

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        ForEach(dataStore?.wrappedValue.categoryStore.allCategories ?? [], id: \.name) { (category) in
                            Button(action: {
                                self.selectedCategory = category
                                self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Text("\(category.name ?? "")")
                            }).foregroundColor(Color(UIColor.label))
                        }
                    } header: {
                        Spacer()
                    } footer: {
                        Button("Add New...") {
                            isAddNewCategorySheetShowing.toggle()
                        }
                    }
                }
            }
            .navigationBarTitle("Select a Category")
            .navigationBarItems(trailing: Button("Cancel", action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
            .sheet(isPresented: $isAddNewCategorySheetShowing) {
                AddNewCategoryView {
                    addCategory(name: $0)
                    isAddNewCategorySheetShowing.toggle()
                }
            }
        }
    }

    // MARK: - Private Methods

    private func addCategory(name: String) {
        guard let context = dataStore?.wrappedValue.context else { return }
        let category = BLCategory(context: context)
        category.name = name
        BLCategory.save(with: context)
    }
}

struct CategorySelection_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return Group {
            CategorySelection(selectedCategory: .constant(BLCategory.mockCategory(withContext: context)))
            CategorySelection(selectedCategory: .constant(BLCategory.mockCategory(withContext: context)))
                .environment(\.colorScheme, .dark)
        }.environment(\.managedObjectContext, context)
    }
}
