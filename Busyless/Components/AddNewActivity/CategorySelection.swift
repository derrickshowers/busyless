//
//  CategorySelection.swift
//  Busyless
//
//  Created by Derrick Showers on 8/16/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct CategorySelection: View {

    // MARK: - Public Properties

    @Binding var selectedCategory: Category?

    // MARK: - Private Properties

    @Environment(\.presentationMode)
    private var presentationMode: Binding<PresentationMode>

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    @FetchRequest(fetchRequest: Category.allCategoriesFetchRequest)
    private var categories: FetchedResults<Category>

    var body: some View {
        List {
            ForEach(categories, id: \.name) { (category) in
                Button(action: {
                    self.selectedCategory = category
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("\(category.name ?? "")")
                }).foregroundColor(Color(UIColor.label))
            }
        }
        .navigationBarTitle("Select a Category")
    }
}

struct CategorySelection_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return Group {
            CategorySelection(selectedCategory: .constant(Category.mockCategory(withContext: context)))
            CategorySelection(selectedCategory: .constant(Category.mockCategory(withContext: context)))
                .environment(\.colorScheme, .dark)
        }.environment(\.managedObjectContext, context)
    }
}
