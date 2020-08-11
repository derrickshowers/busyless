//
//  DayView.swift
//  TimeBudget
//
//  Created by Derrick Showers on 8/8/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import CoreData
import os

struct DayView: View {
    @State private var showingAddNewActivityView = false

    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Category.name, ascending: true)
        ]
    ) var categories: FetchedResults<Category>

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(categories, id: \.name) {
                        CategoryRow(category: $0)
                    }
                    .onDelete(perform: deleteCategory)
                    AddNewCategoryRow { (newCategory: String) in
                        self.addCategory(name: newCategory)
                    }

                }
                .onAppear {
                    UITableView.appearance().separatorStyle = .none
                }
                HStack {
                    Spacer()
                    AddButton {
                        self.showingAddNewActivityView.toggle()
                    }
                }
            }
            .navigationBarTitle("Today")
        }
        .sheet(isPresented: $showingAddNewActivityView) {
            AddNewActivityView()
        }
    }

    // MARK: - Core Data

    private func save() {
        do {
            try managedObjectContext.save()
        } catch {
            os_log("Issue saving data")
        }
    }

    private func addCategory(name: String) {
        let category = Category(context: managedObjectContext)
        category.name = name
        save()
    }

    private func deleteCategory(at offsets: IndexSet) {
      offsets.forEach { index in
        let category = self.categories[index]
        self.managedObjectContext.delete(category)
      }
      save()
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        return DayView().environment(\.managedObjectContext, context)
    }
}
