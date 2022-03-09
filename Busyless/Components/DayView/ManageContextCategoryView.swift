//
//  ManageContextCategoryView.swift
//  Busyless
//
//  Created by Derrick Showers on 1/16/21.
//  Copyright © 2021 Derrick Showers. All rights reserved.
//

import BusylessDataLayer
import SwiftUI

struct ManageContextCategoryView: View {
    // MARK: - Public Properties

    let contextCategories: [ContextCategory]
    let onAdd: (String) -> Void
    let onDelete: ([ContextCategory]) -> Void
    let onComplete: () -> Void

    // MARK: - Private Properties

    @State private var categoryName = ""
    @State private var isFirstResponder = true

    // MARK: - Lifecycle

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    let footerText =
                        "Context categories are used to group categories. For instance, work and personal, or morning and evening."
                    let addButton = Button("Add") { onAdd(categoryName) }.disabled(categoryName.isEmpty)
                    Section(
                        header: addButton.frame(maxWidth: .infinity, alignment: .trailing).padding(.top, 25),
                        footer: Text(footerText).padding(.bottom, 25)
                    ) {
                        FirstResponderTextField(
                            "Context Category Name",
                            text: $categoryName,
                            isFirstResponder: $isFirstResponder
                        )
                    }

                    Section(
                        header: EditButton().frame(maxWidth: .infinity, alignment: .trailing)
                            .overlay(Text("Existing Context Categories"), alignment: .leading)
                    ) {
                        List {
                            ForEach(contextCategories, id: \.self) { (contextCategory: ContextCategory) in
                                Text(contextCategory.name ?? "")
                            }
                            .onDelete(perform: { offsets in
                                let contextCategoriesToDelete = offsets.map { contextCategories[$0] }
                                onDelete(contextCategoriesToDelete)
                            })
                        }
                    }
                }
                Spacer()
            }
            .navigationBarTitle("Manage")
            .navigationBarItems(trailing: Button("Done", action: {
                onComplete()
            }))
        }
    }
}

struct ManageContextCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        let mockContextCategory = ContextCategory.mockContextCategory()
        ManageContextCategoryView(
            contextCategories: [mockContextCategory],
            onAdd: { _ in },
            onDelete: { _ in },
            onComplete: {}
        )
    }
}
