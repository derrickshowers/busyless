//
//  ContextCategorySelection.swift
//  Busyless
//
//  Created by Derrick Showers on 12/21/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import BusylessDataLayer
import SwiftUI

struct ContextCategorySelection: View {
    // MARK: - Public Properties

    @Binding var selectedContextCategory: ContextCategory?

    // MARK: - Private Properties

    @Environment(\.presentationMode)
    private var presentationMode: Binding<PresentationMode>

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    @Environment(\.dataStore)
    private var dataStore

    var body: some View {
        List {
            ForEach(dataStore?.wrappedValue.categoryStore.allContextCategories ?? [], id: \.name) { contextCategory in
                Button(action: {
                    self.selectedContextCategory = contextCategory
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("\(contextCategory.name ?? "")")
                }).foregroundColor(Color(UIColor.label))
            }

            Button(action: {
                self.selectedContextCategory = nil
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("None")
            }).foregroundColor(Color(UIColor.label))
        }
        .navigationBarTitle("Context Category")
    }
}

// MARK: - Preview

struct ContextCategorySelection_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return Group {
            ContextCategorySelection(selectedContextCategory: .constant(
                ContextCategory
                    .mockContextCategory(withContext: context)
            ))
            ContextCategorySelection(selectedContextCategory: .constant(
                ContextCategory
                    .mockContextCategory(withContext: context)
            ))
            .environment(\.colorScheme, .dark)
        }.environment(\.managedObjectContext, context)
    }
}
