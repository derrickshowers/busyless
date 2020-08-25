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
        .onAppear {
            UITableView.appearance().separatorStyle = .singleLine
        }
        .navigationBarTitle("Select a Category")
    }
}

struct CategorySelection_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next force_cast
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return Group {
            CategorySelection(selectedCategory: .constant(Category.mockCategory))
            CategorySelection(selectedCategory: .constant(Category.mockCategory))
                .environment(\.colorScheme, .dark)
        }.environment(\.managedObjectContext, context)
    }
}
