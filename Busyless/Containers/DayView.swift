//
//  DayView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/8/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import CoreData
import os

struct DayView: View {

    // MARK: - Private Properties

    @State private var showingAddNewActivityView = false

    @Environment(\.presentationMode)
    private var presentationMode: Binding<PresentationMode>

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    @FetchRequest(fetchRequest: Category.allCategoriesFetchRequest)
    private var categories: FetchedResults<Category>

    @FetchRequest(fetchRequest: UserConfig.allUserConfigsFetchRequest)
    private var userConfigs: FetchedResults<UserConfig>

    private var totalBudgetedDuration: TimeInterval {
        return self.categories.reduce(0) { $0 + $1.dailyBudgetDuration }
    }

    private var awakeDuration: TimeInterval {
        guard let userConfig = self.userConfigs.first,
            let awakeTime = userConfig.awakeTime,
            let sleepTime = userConfig.sleepTime else {
                return SettingsView.awakeDurationDefault
        }

        // If sleep time is before awake time, 1 day needs to be added to get correct duration.
        var validatedSleepTime = sleepTime
        if sleepTime < awakeTime {
            validatedSleepTime = Calendar.current.date(byAdding: .day, value: 1, to: sleepTime) ?? sleepTime
        }

        let difference = Calendar.current.dateComponents([.hour, .minute], from: awakeTime, to: validatedSleepTime)
        return TimeInterval(difference.hour ?? 0) * TimeInterval.oneHour
    }

    // MARK: - Lifecycle

    var body: some View {
        ZStack {
            VStack {
                TodayStatus(awakeDuration: awakeDuration, totalBudgetedDuration: totalBudgetedDuration)
                List {
                    AddNewCategoryRow { (newCategory: String) in
                        self.addCategory(name: newCategory)
                    }
                    ForEach(categories, id: \.name) { category in
                        ZStack {
                            CategoryRow(category: category)
                            NavigationLink(destination: CategoryDetailView(category: category)) {
                                EmptyView()
                            }
                        }
                    }
                    .onDelete(perform: deleteCategory)
                }

            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddButton {
                        self.showingAddNewActivityView.toggle()
                    }
                }
            }
        }
        .navigationBarTitle("Today")
        .sheet(isPresented: $showingAddNewActivityView) {
            AddNewActivityView(isPresented: self.$showingAddNewActivityView)
                .environment(\.managedObjectContext, self.managedObjectContext)
        }
    }
}

// MARK: - Core Data

extension DayView {

    private func addCategory(name: String) {
        let category = Category(context: managedObjectContext)
        category.name = name
        Category.save(with: managedObjectContext)
    }

    private func deleteCategory(at offsets: IndexSet) {
        offsets.forEach { index in
            let category = self.categories[index]
            self.managedObjectContext.delete(category)
        }
        Category.save(with: managedObjectContext)
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return DayView().environment(\.managedObjectContext, context)
    }
}
