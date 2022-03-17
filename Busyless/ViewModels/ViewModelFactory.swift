//
//  ViewModelFactory.swift
//  Busyless
//
//  Created by Derrick Showers on 1/13/22.
//  Copyright © 2022 Derrick Showers. All rights reserved.
//

import BusylessDataLayer
import Foundation

class ViewModelFactory {
    private let dataStore = DataStore(managedObjectContext: PersistenceController.shared.container.viewContext)

    func makeMainViewModel() -> MainViewModel {
        let addNewActivityView = AddNewActivityView(viewModel: makeAddNewActivityViewModel())
        let logView = LogView(viewModel: makeLogViewModel())
        let monthView = MonthView(viewModel: makeMonthViewModel())
        return MainViewModel(
            addNewActivityView: addNewActivityView,
            logView: logView,
            monthView: monthView
        )
    }

    private func makeAddNewActivityViewModel(with activity: Activity? = nil) -> AddNewActivityViewModel {
        return AddNewActivityViewModel(dataStore: dataStore, activity: activity)
    }

    private func makeLogViewModel() -> LogViewModel {
        return LogViewModel(dataStore: dataStore) { [unowned self] in
            AddNewActivityView(viewModel: self.makeAddNewActivityViewModel(with: $0))
        }
    }

    private func makeMonthViewModel() -> MonthViewModel {
        return MonthViewModel(dataStore: dataStore)
    }
}
