//
//  MonthView.swift
//  Busyless
//
//  Created by Derrick Showers on 11/2/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import BusylessDataLayer
import SwiftUI

struct MonthView: View {
    // MARK: - Properties

    @ObservedObject private var viewModel: MonthViewModel

    // MARK: - Initialization

    init(viewModel: MonthViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Lifecycle

    var body: some View {
        VStack {
            PieChartView(slices: viewModel.slices)
            PieChartRows(slices: viewModel.slices)
        }
        .padding()
    }
}

// MARK: - Testing/Previews

extension MonthView {
    static func forTesting() -> MonthView {
        let mockDataStore = DataStore(managedObjectContext: PersistenceController.preview.container.viewContext)
        let mockViewModel = MonthViewModel(dataStore: mockDataStore)
        return Self(viewModel: mockViewModel)
    }
}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let dataStore = ObservedObject(initialValue: DataStore(managedObjectContext: context))
        return Group {
            MonthView.forTesting()
                .environment(\.managedObjectContext, context)
                .environment(\.dataStore, dataStore)
            MonthView.forTesting()
                .environment(\.managedObjectContext, context)
                .environment(\.dataStore, dataStore)
                .environment(\.colorScheme, .dark)
        }
    }
}
