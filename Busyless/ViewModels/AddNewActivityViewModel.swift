//
//  AddNewActivityViewModel.swift
//  Busyless
//
//  Created by Derrick Showers on 1/18/22.
//  Copyright © 2022 Derrick Showers. All rights reserved.
//

import Foundation
import BusylessDataLayer
import CoreData

class AddNewActivityViewModel: ObservableObject {

    // MARK: - Properties

    @Published var activity: Activity

    // MARK: - Initialization

    private let dataStore: DataStore
    private var childContext: NSManagedObjectContext {
        didSet { childContext.parent = dataStore.context }
    }

    init(dataStore: DataStore, activity: Activity? = nil) {
        self.dataStore = dataStore
        self.childContext = NSManagedObjectContext(.mainQueue)
        self.activity = activity ?? Activity(context: childContext)

        childContext.parent = dataStore.context
    }
}
