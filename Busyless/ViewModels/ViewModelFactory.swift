//
//  ViewModelFactory.swift
//  Busyless
//
//  Created by Derrick Showers on 1/13/22.
//  Copyright © 2022 Derrick Showers. All rights reserved.
//

import Foundation
import BusylessDataLayer

class ViewModelFactory {
    private let dataStore = DataStore(managedObjectContext: PersistenceController.shared.container.viewContext)

    func makeMainViewModel() -> MainViewModel {
        let logView = LogView(viewModel: self.makeLogViewModel())
        return MainViewModel(logView: logView)
    }

    private func makeLogViewModel() -> LogViewModel {
        return LogViewModel(dataStore: dataStore)
    }
}
