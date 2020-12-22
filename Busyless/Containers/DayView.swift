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
    @State private var addingNewContextCategory = false

    @Environment(\.presentationMode)
    private var presentationMode: Binding<PresentationMode>

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    @Environment(\.dataStore)
    private var dataStore

    private var totalBudgetedDuration: TimeInterval {
        return self.categories.reduce(0) { $0 + $1.dailyBudgetDuration }
    }

    private var categories: [BLCategory] {
        return dataStore?.wrappedValue.categoryStore.allCategories ?? []
    }

    private var contextCategories: [ContextCategory] {
        return dataStore?.wrappedValue.categoryStore.allContextCategories ?? []
    }

    private var categoriesWithNoContextCategory: [BLCategory] {
        return categories.filter { $0.contextCategory == nil }
    }

    private var awakeDuration: TimeInterval {
        guard let awakeTime = dataStore?.wrappedValue.userConfigStore.awakeTime,
              let sleepTime = dataStore?.wrappedValue.userConfigStore.sleepTime else {
            return UserConfigStore.awakeDurationDefault
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
                    // Categories with a context category
                    ForEach(contextCategories, id: \.name) { (contextCategory: ContextCategory) in
                        if let categories = contextCategory.categories?.allObjects as? [BLCategory] {
                            ContextCategorySection(sectionTitle: contextCategory.name,
                                                   sectionSubtitle: contextCategory.timeBudgeted.hoursMinutesString,
                                                   categories: categories) { row in
                                deleteCategory(at: row.map({$0}).first ?? 0, contextCategory: contextCategory)
                            }
                        }
                    }.listRowBackground(Color.customWhite)

                    // All other categories
                    ContextCategorySection(categories: categoriesWithNoContextCategory) { row in
                        deleteCategory(at: row.map({$0}).first ?? 0)
                    }.listRowBackground(Color.customWhite)
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddButton {
                        showingAddNewActivityView.toggle()
                    }
                }
                .sheet(isPresented: $showingAddNewActivityView) {
                    AddNewActivityView(isPresented: $showingAddNewActivityView)
                        .environment(\.managedObjectContext, managedObjectContext)
                }
            }
        }
        .background(Color(UIColor.systemGray6))
        .navigationBarTitle("Today")
        .navigationBarItems(trailing: MoreOptionsMenuButton(categories: categories,
                                                            addCategoryAction: {
                                                                addingNewContextCategory = false
                                                                showingAddNewCategoryView = true
                                                            }, addContextCategoryAction: {
                                                                addingNewContextCategory = true
                                                                showingAddNewCategoryView = true
                                                            }).sheet(isPresented: $showingAddNewCategoryView) {
                                                                AddNewCategoryView(isContextCategory: addingNewContextCategory) {
                                                                    if addingNewContextCategory {
                                                                        addContextCategory(name: $0)
                                                                    } else {
                                                                        addCategory(name: $0)
                                                                    }
                                                                    showingAddNewCategoryView = false
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

    private func addContextCategory(name: String) {
        let contextCategory = ContextCategory(context: managedObjectContext)
        contextCategory.name = name
        ContextCategory.save(with: managedObjectContext)
    }

    private func deleteCategory(at index: Int, contextCategory: ContextCategory? = nil) {
        if let contextCategory = contextCategory,
           let category = contextCategory.categories?.allObjects[index] as? BLCategory {
            self.managedObjectContext.delete(category)
        } else {
            let category = self.categoriesWithNoContextCategory[index]
            self.managedObjectContext.delete(category)
        }
        BLCategory.save(with: managedObjectContext)
    }
}

// MARK: - Extracted Views

struct MoreOptionsMenuButton: View {

    // MARK: - Public Properties

    let categories: [BLCategory]
    let addCategoryAction: () -> Void
    let addContextCategoryAction: () -> Void

    // MARK: - Private Properties
    @Environment(\.managedObjectContext)
    private var managedObjectContext

    // MARK: - Lifecycle

    var body: some View {
        Menu(content: {
            Button("Add Category") {
                addCategoryAction()
            }
            Button("Add Context Category") {
                addContextCategoryAction()
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

    let isContextCategory: Bool
    let action: (String) -> Void

    // MARK: - Private Properties

    @State private var categoryName = ""
    @State private var isFirstResponder = true

    // MARK: - Lifecycle

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    FirstResponderTextField(isContextCategory ? "Context Category Name" : "Category Name",
                                            text: $categoryName,
                                            isFirstResponder: $isFirstResponder)
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

struct ContextCategorySection: View {

    // MARK: - Public Properties

    var sectionTitle: String?
    var sectionSubtitle: String?
    let categories: [BLCategory]
    let onDelete: (IndexSet) -> Void

    // MARK: - Lifecycle

    var body: some View {
        Section(header: ContextCategoryHeader(name: sectionTitle ?? "Other", timeBudgetedString: sectionSubtitle)) {
            ForEach(categories, id: \.name) { category in
                ZStack {
                    CategoryRow(category: category)
                    NavigationLink(destination: CategoryDetailView(category: category, overviewType: .day)) { }.opacity(0)
                }
            }
            .onDelete(perform: onDelete)
        }
    }
}

struct ContextCategoryHeader: View {

    // MARK: - Public Properties

    let name: String
    let timeBudgetedString: String?

    // MARK: - Lifecycle

    var body: some View {
        HStack {
            Text(name)
            if let timeBudgetedString = timeBudgetedString {
                Spacer()
                Text(timeBudgetedString)
            }

        }
    }
}

// MARK: - Preview

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let dataStore = ObservedObject(initialValue: DataStore(managedObjectContext: context))
        return Group {
            DayView()
                .environment(\.managedObjectContext, context)
                .environment(\.dataStore, dataStore)
            DayView().environment(\.managedObjectContext, context)
                .environment(\.managedObjectContext, context)
                .environment(\.dataStore, dataStore)
                .environment(\.colorScheme, .dark)
        }
    }
}
