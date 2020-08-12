//
//  AddNewCategoryRow.swift
//  TimeBudget
//
//  Created by Derrick Showers on 8/10/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct AddNewCategoryRow: View {

    // MARK: - Public Properties
    let newCategoryAdded: (String) -> Void

    // MARK: - Private Properties
    @State private var newCategory = ""
    @State private var isEditing = false

    var body: some View {
        HStack {
            if isEditing {
                HStack {
                    TextField("Enter a new category", text: $newCategory, onCommit: {
                        self.newCategoryAdded(self.newCategory)
                        self.newCategory = ""
                        self.isEditing = false
                    })
                        .font(.body)
                        .foregroundColor(Color.black)
                    Button(action: {
                        self.isEditing.toggle()
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(Color.gray)
                    })
                }
            } else {
                Button(action: {
                    self.isEditing.toggle()
                }, label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add new category")
                    }
                }).foregroundColor(Color.gray)
                Spacer()
            }
        }
    }
}

struct AddNewCategoryRow_Previews: PreviewProvider {
    @State private var newCategory = ""
    static var previews: some View {
        AddNewCategoryRow { _ in }
            .padding()
    }
}
