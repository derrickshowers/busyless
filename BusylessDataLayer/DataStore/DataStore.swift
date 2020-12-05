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
}
