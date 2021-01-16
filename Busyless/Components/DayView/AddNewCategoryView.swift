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

    // MARK: - Lifecycle

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    let footerText = "Categories are used to assign activities and budget time accordingly."
                    Section(footer: Text(footerText).padding(.bottom, 25)) {
                        FirstResponderTextField("Category Name",
                                                text: $categoryName,
                                                isFirstResponder: $isFirstResponder)
                    }
                }
                Spacer()
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
