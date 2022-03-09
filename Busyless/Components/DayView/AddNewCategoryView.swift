//
//  AddNewCategoryView.swift
//  Busyless
//
//  Created by Derrick Showers on 1/16/21.
//  Copyright © 2021 Derrick Showers. All rights reserved.
//

import SwiftUI

struct AddNewCategoryView: View {
    // MARK: - Public Properties

    let action: (String) -> Void

    // MARK: - Private Properties

    @State private var categoryName = ""
    @State private var isFirstResponder = true
    @FocusState private var categoryNameFocused: Bool?

    // MARK: - Lifecycle

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Category Name", text: $categoryName)
                        .focused($categoryNameFocused, equals: true)
                } header: {
                    Spacer()
                } footer: {
                    Text("Categories are used to assign activities and budget time accordingly.")
                        .padding(.bottom, 25)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    categoryNameFocused = true
                }
            }
            .navigationBarTitle("Add Category")
            .navigationBarItems(trailing: Button("Add", action: {
                action(categoryName)
            }))
        }
    }
}

struct AddNewCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCategoryView { _ in }
    }
}
