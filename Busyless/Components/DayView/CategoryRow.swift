//
//  CategoryRow.swift
//  Busyless
//
//  Created by Derrick Showers on 8/11/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import BusylessDataLayer

struct CategoryRow: View {

    // MARK: - Public Properties

    @ObservedObject var category = BLCategory()

    // MARK: - Lifecycle

    var body: some View {
        HStack {
            Text(category.name ?? "")
                .opacity(0.8)
            Spacer()
            DurationPill(dailyBudgetDuration: category.dailyBudgetDuration,
                         timeSpentDuration: category.timeSpentToday)
        }
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRow(category: BLCategory.mockCategory()).padding()
    }
}
