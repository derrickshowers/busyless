//
//  DayView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/8/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import CoreData
import BusylessDataLayer
import os

struct DayView: View {

    // MARK: - Private Properties

    @State private var showingAddNewActivityView = false
    @State private var showingAddNewCategoryView = false

    @Environment(\.presentationMode)
    private var presentationMode: Binding<PresentationMode>

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    @FetchRequest(fetchRequest: BLCategory.allCategoriesFetchRequest)
    private var categories: FetchedResults<BLCategory>

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
            VStack(spacing: 0) {
                TodayStatus(awakeDuration: awakeDuration, totalBudgetedDuration: totalBudgetedDuration)
                List {
                    ForEach(categories, id: \.name) { category in
                        ZStack {
                            CategoryRow(category: category)
                            NavigationLink(destination: CategoryDetailView(category: category)) {
                                EmptyView()
                            }
                        }
                    }
                    .onDelete(perform: deleteCategory)
                    .listRowBackground(Color.customWhite)
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
                .sheet(isPresented: $showingAddNewActivityView) {
                    AddNewActivityView(isPresented: self.$showingAddNewActivityView)
                        .environment(\.managedObjectContext, self.managedObjectContext)
                }
            }
        }
        .background(Color(UIColor.systemGray6))
        .navigationBarTitle("Today")
        .navigationBarItems(trailing: MoreOptionsMenuButton(categories: categories) {
            self.showingAddNewCategoryView = true
        }.sheet(isPresented: $showingAddNewCategoryView) {
            AddNewCategoryView {
                self.addCategory(name: $0)
                self.showingAddNewCategoryView = false
            }
        })
    }
}

// MARK: - Core Data

extension DayView {

    private func addCategory(name: String) {
        let category = BLCategory(context: managedObjectContext)
        category.name = name
        BLCategory.save(with: managedObjectContext)
    }

    private func deleteCategory(at offsets: IndexSet) {
        offsets.forEach { index in
            let category = self.categories[index]
            self.managedObjectContext.delete(category)
        }
        BLCategory.save(with: managedObjectContext)
    }
}

struct MoreOptionsMenuButton: View {

    // MARK: - Public Properties

    let categories: FetchedResults<BLCategory>
    let addCategoryAction: () -> Void

    // MARK: - Private Properties
    @Environment(\.managedObjectContext)
    private var managedObjectContext

    // MARK: - Lifecycle

    var body: some View {
        Menu(content: {
            Button("Add Category") {
                addCategoryAction()
            }
            Button("Reset Budget") {
                categories.forEach { $0.dailyBudgetDuration = 0 }
                BLCategory.save(with: managedObjectContext)
            }
        }, label: {
            Image(systemName: "ellipsis.circle").frame(minWidth: 44, minHeight: 44)
        })
    }
}

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
                    FirstResponderTextField("Category Name", text: $categoryName, isFirstResponder: $isFirstResponder)
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

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return Group {
            DayView().environment(\.managedObjectContext, context)
            DayView().environment(\.managedObjectContext, context).environment(\.colorScheme, .dark)
        }
    }
}
