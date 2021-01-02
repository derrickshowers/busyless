//
//  DataStore.swift
//  BusylessDataLayer
//
//  Created by Derrick Showers on 12/6/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import Foundation
import CoreData
import Combine

public class DataStore: ObservableObject {

    @Published public var categoryStore: CategoryStore
    @Published public var activityStore: ActivityStore
    @Published public var userConfigStore: UserConfigStore

    private var cancellables: [AnyCancellable] = []

    public init(managedObjectContext: NSManagedObjectContext) {
        categoryStore = CategoryStore(managedObjectContext: managedObjectContext)
        activityStore = ActivityStore(managedObjectContext: managedObjectContext)
        userConfigStore = UserConfigStore(managedObjectContext: managedObjectContext)

        // Necessary to bubble up changes for published properties in individual data stores.
        cancellables.append(categoryStore.objectWillChange.sink(receiveValue: { [weak self] (_) in
            self?.objectWillChange.send()
        }))
        cancellables.append(activityStore.objectWillChange.sink(receiveValue: { [weak self] (_) in
            self?.objectWillChange.send()
        }))
        cancellables.append(userConfigStore.objectWillChange.sink(receiveValue: { [weak self] (_) in
            self?.objectWillChange.send()
        }))
    }

    // MARK: - Public Methods

    public func addOnboardingData() -> Bool {
        guard categoryStore.allCategories.count == 0, activityStore.allActivities.count == 0 else {
            return false
        }
        let moc = PersistenceController.shared.container.viewContext

        // Context Categories
        let contextCategory1 = ContextCategory(context: moc)
        contextCategory1.name = "Personal"
        let contextCategory2 = ContextCategory(context: moc)
        contextCategory2.name = "Professional"

        // Categories
        let category1 = BLCategory(context: moc)
        category1.name = "Meditation"
        category1.dailyBudgetDuration = 1800
        category1.contextCategory = contextCategory1
        let category2 = BLCategory(context: moc)
        category2.name = "Journaling"
        category2.dailyBudgetDuration = 1800
        category2.contextCategory = contextCategory1
        let category3 = BLCategory(context: moc)
        category3.name = "Meetings"
        category3.dailyBudgetDuration = 3600
        category3.contextCategory = contextCategory2

        // Activities
        let activity1 = Activity(context: moc)
        activity1.name = "10% Happier Daily Meditation"
        activity1.createdAt = Date()
        activity1.duration = 900
        activity1.category = category1
        let activity2 = Activity(context: moc)
        activity2.name = "Daily Prompt"
        activity2.createdAt = Calendar.current.date(byAdding: .hour, value: -1, to: Date())
        activity2.duration = 900
        activity2.category = category2
        let activity3 = Activity(context: moc)
        activity3.name = "Thought Reflection"
        activity3.createdAt = Calendar.current.date(byAdding: .hour, value: -3, to: Date())
        activity3.duration = 900
        activity3.category = category2
        let activity4 = Activity(context: moc)
        activity4.name = "Sprint Planning"
        activity4.createdAt = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        activity4.duration = 3600
        activity4.category = category3

        try? moc.save()

        return true
    }
}
