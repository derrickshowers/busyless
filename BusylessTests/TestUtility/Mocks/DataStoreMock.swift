//
//  DataStoreMock.swift
//  BusylessTests
//
//  Created by Derrick Showers on 2/5/21.
//  Copyright © 2021 Derrick Showers. All rights reserved.
//

import SwiftUI
import ViewInspector
import CoreData
@testable import Busyless
@testable import BusylessDataLayer

class DataStoreMock {

    let dataStore: DataStore
    let context:  NSManagedObjectContext
    var dataStoreObservable: ObservedObject<DataStore> {
        return ObservedObject<DataStore>(wrappedValue: dataStore)
    }

    init() {
        let result = PersistenceController(inMemory: true)
        context = result.container.viewContext
        dataStore = DataStoreMock.defaultDataStore(withContext: context)
    }

    /**
     Sets up a data store with default models. Use for most cases where specific data is not important.
     */
    private static func defaultDataStore(withContext context: NSManagedObjectContext) -> DataStore {
        let contextCategory = ContextCategory.mockContextCategory(withContext: context)
        let category = BLCategory.mockCategory(withContext: context)
        let activity = Activity.mockActivity(withContext: context)
        category.contextCategory = contextCategory
        activity.category = category
        try? context.save()
        return DataStore(managedObjectContext: context)
    }
}
