//
//  DataStore.swift
//  BusylessDataLayer
//
//  Created by Derrick Showers on 12/6/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import Combine
import CoreData
import Foundation

public class DataStore: ObservableObject {
    public let context: NSManagedObjectContext
    @Published public var categoryStore: CategoryStore
    @Published public var activityStore: ActivityStore
    @Published public var userConfigStore: UserConfigStore

    private var cancellables: [AnyCancellable] = []

    public init(managedObjectContext: NSManagedObjectContext) {
        context = managedObjectContext
        categoryStore = CategoryStore(managedObjectContext: managedObjectContext)
        activityStore = ActivityStore(managedObjectContext: managedObjectContext)
        userConfigStore = UserConfigStore(managedObjectContext: managedObjectContext)

        // Necessary to bubble up changes for published properties in individual data stores.
        cancellables.append(categoryStore.objectWillChange.sink(receiveValue: { [weak self] _ in
            self?.objectWillChange.send()
        }))
        cancellables.append(activityStore.objectWillChange.sink(receiveValue: { [weak self] _ in
            self?.objectWillChange.send()
        }))
        cancellables.append(userConfigStore.objectWillChange.sink(receiveValue: { [weak self] _ in
            self?.objectWillChange.send()
        }))
    }

    // MARK: - Public Methods

    public func addOnboardingData() -> Bool {
        guard categoryStore.allCategories.count == 0, activityStore.allActivities.count == 0 else {
            return false
        }
        let moc = PersistenceController.shared.container.viewContext

        let contextCategories = createMockContextCategories(managedObjectContext: moc)
        let categories = createMockCategories(with: contextCategories, managedObjectContext: moc)
        createMockActivities(with: categories, managedObjectContext: moc)

        try? moc.save()

        return true
    }
}

extension DataStore {
    private enum DictionaryKeyConstants {
        static let personalContextCategory = "personal"
        static let professionalContextCategory = "profressional"
        static let meditationCategory = "meditation"
        static let journalingCategory = "journaling"
        static let meetingsCategory = "meetings"
    }

    private func createMockContextCategories(managedObjectContext moc: NSManagedObjectContext)
        -> [String: ContextCategory] {
        let personalContextCategory = ContextCategory(context: moc)
        personalContextCategory.name = "Personal"
        let professionalContextCategory = ContextCategory(context: moc)
        professionalContextCategory.name = "Professional"

        return [
            DictionaryKeyConstants.personalContextCategory: personalContextCategory,
            DictionaryKeyConstants.professionalContextCategory: professionalContextCategory,
        ]
    }

    private func createMockCategories(
        with contextCategories: [String: ContextCategory],
        managedObjectContext moc: NSManagedObjectContext
    ) -> [String: BLCategory] {
        let meditationCategory = BLCategory(context: moc)
        meditationCategory.name = "Meditation"
        meditationCategory.dailyBudgetDuration = 1800
        meditationCategory.contextCategory = contextCategories[DictionaryKeyConstants.personalContextCategory]

        let journalingCategory = BLCategory(context: moc)
        journalingCategory.name = "Journaling"
        journalingCategory.dailyBudgetDuration = 1800
        journalingCategory.contextCategory = contextCategories[DictionaryKeyConstants.personalContextCategory]

        let meetingsCategory = BLCategory(context: moc)
        meetingsCategory.name = "Meetings"
        meetingsCategory.dailyBudgetDuration = 3600
        meetingsCategory.contextCategory = contextCategories[DictionaryKeyConstants.professionalContextCategory]

        return [
            DictionaryKeyConstants.meditationCategory: meditationCategory,
            DictionaryKeyConstants.journalingCategory: journalingCategory,
            DictionaryKeyConstants.meetingsCategory: meetingsCategory,
        ]
    }

    private func createMockActivities(
        with categories: [String: BLCategory],
        managedObjectContext moc: NSManagedObjectContext
    ) {
        let meditationActivity = Activity(context: moc)
        meditationActivity.name = "10% Happier Daily Meditation"
        meditationActivity.createdAt = Date()
        meditationActivity.duration = 900
        meditationActivity.category = categories[DictionaryKeyConstants.meditationCategory]

        let dailyPromptActivity = Activity(context: moc)
        dailyPromptActivity.name = "Daily Prompt"
        dailyPromptActivity.createdAt = Calendar.current.date(byAdding: .hour, value: -1, to: Date())
        dailyPromptActivity.duration = 900
        dailyPromptActivity.category = categories[DictionaryKeyConstants.journalingCategory]

        let thoughtReflectionActivity = Activity(context: moc)
        thoughtReflectionActivity.name = "Thought Reflection"
        thoughtReflectionActivity.createdAt = Calendar.current.date(byAdding: .hour, value: -3, to: Date())
        thoughtReflectionActivity.duration = 900
        thoughtReflectionActivity.category = categories[DictionaryKeyConstants.journalingCategory]

        let sprintPlanningActivity = Activity(context: moc)
        sprintPlanningActivity.name = "Sprint Planning"
        sprintPlanningActivity.createdAt = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        sprintPlanningActivity.duration = 3600
        sprintPlanningActivity.category = categories[DictionaryKeyConstants.meetingsCategory]
    }
}
