//
//  CategoryRow.swift
//  TimeBudget
//
//  Created by Derrick Showers on 8/11/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct CategoryRow: View {
    @ObservedObject var category = Category()

    var body: some View {
        HStack {
            Text(category.name ?? "")
                .opacity(0.8)
            Spacer()
            DurationPill(timeSpentDuration: category.timeSpentDuration,
                         dailyBudgetDuration: $category.dailyBudgetDuration)
        }
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRow(category: Category.mockCategory).padding()
    }
}
