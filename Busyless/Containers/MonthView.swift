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
        NavigationView {
            VStack {
                Picker("Month Selection", selection: $viewModel.selectedMonth) {
                    Text("This Month").tag(SelectedMonth.currentMonth)
                    Text("Last Month").tag(SelectedMonth.lastMonth)
                }

                PieChartView(slices: viewModel.categories)
                    .padding(50)
                PieChartRows(slices: viewModel.categories)
                    .padding(.horizontal, 15)
                Spacer()
            }
            .navigationBarTitle("This Month")
        }
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
