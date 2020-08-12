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

    // MARK: - Constants
    static let awakeDuration = 16

    // MARK: - Private Properties
    @State private var showingAddNewActivityView = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Category.name, ascending: true)
        ]
    ) private var categories: FetchedResults<Category>
    private var totalBudgetedDuration: Int {
        var duration = 0
        self.categories.forEach { (category: Category) in
            duration += Int(category.dailyBudgetDuration)
        }
        return duration
    }

    var body: some View {
        VStack {
            TodayStatus(awakeDuration: DayView.awakeDuration, totalBudgetedDuration: totalBudgetedDuration)
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
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return DayView().environment(\.managedObjectContext, context)
    }
}
