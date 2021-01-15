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

    private enum ActiveSheet: Identifiable {
        case addNewCategory, manageContextCategory, addNewActivity

        var id: Int {
            hashValue
        }
    }

    @State private var activeSheet: ActiveSheet?

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
                        if let categories = (contextCategory.categories?.allObjects as? [BLCategory])?.sorted { $0.name ?? "" < $1.name ?? "" } {
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
                        activeSheet = .addNewActivity
                    }
                }
            }
        }
        .background(Color(UIColor.systemGray6))
        .navigationBarTitle("Hello world!")
        .navigationBarItems(trailing: MoreOptionsMenuButton(categories: categories,
                                                            addCategoryAction: {
                                                                activeSheet = .addNewCategory
                                                            }, addContextCategoryAction: {
                                                                activeSheet = .manageContextCategory
                                                            }))
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .addNewActivity:
                AddNewActivityView {
                    activeSheet = nil
                }
            case .addNewCategory:
                AddNewCategoryView {
                    addCategory(name: $0)
                    activeSheet = nil
                }
            case .manageContextCategory:
                ManageContextCategoryView(contextCategories: contextCategories, onAdd: {
                    addContextCategory(name: $0)
                }, onDelete: {
                    deleteContextCategories($0)
                }, onComplete: {
                    activeSheet = nil
                })
            }
        }
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

    private func deleteContextCategories(_ contextCategories: [ContextCategory]) {
        contextCategories.forEach { managedObjectContext.delete($0) }
        ContextCategory.save(with: managedObjectContext)
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
            Button("Manage Context Categories") {
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

struct ManageContextCategoryView: View {

    // MARK: - Public Properties

    let contextCategories: [ContextCategory]
    let onAdd: (String) -> Void
    let onDelete: ([ContextCategory]) -> Void
    let onComplete: () -> Void

    // MARK: - Private Properties

    @State private var categoryName = ""
    @State private var isFirstResponder = true

    // MARK: - Lifecycle

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    let footerText = "Context categories are used to group categories. For instance, work and personal, or morning and evening."
                    let addButton = Button("Add") { onAdd(categoryName) }
                    Section(header: addButton.frame(maxWidth: .infinity, alignment: .trailing).padding(.top, 25),
                            footer: Text(footerText).padding(.bottom, 25)) {
                        FirstResponderTextField("Context Category Name",
                                                text: $categoryName,
                                                isFirstResponder: $isFirstResponder)
                    }

                    Section(header: EditButton().frame(maxWidth: .infinity, alignment: .trailing)
                                .overlay(Text("Existing Context Categories"), alignment: .leading)) {
                        List {
                            ForEach(contextCategories, id: \.self) { (contextCategory: ContextCategory) in
                                Text(contextCategory.name ?? "")
                            }
                            .onDelete(perform: { offsets in
                                let contextCategoriesToDelete = offsets.map { contextCategories[$0] }
                                onDelete(contextCategoriesToDelete)
                            })
                        }
                    }

                }
                Spacer()
            }
            .navigationBarTitle("Manage")
            .navigationBarItems(trailing: Button("Done", action: {
                onComplete()
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
