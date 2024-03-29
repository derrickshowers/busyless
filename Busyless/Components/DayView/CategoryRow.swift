//
//  CategoryRow.swift
//  Busyless
//
//  Created by Derrick Showers on 8/11/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import BusylessDataLayer
import SwiftUI

struct CategoryRow: View {
    // MARK: - Public Properties

    @ObservedObject var category = BLCategory()

    // MARK: - Lifecycle

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(category.name ?? "")
                    .opacity(0.8)
                if let notes = category.notes, !notes.isEmpty {
                    Text(notes)
                        .lineLimit(1)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            DurationPill(
                dailyBudgetDuration: category.dailyBudgetDuration,
                timeSpentDuration: category.timeSpentToday
            )
        }
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRow(category: BLCategory.mockCategory()).padding()
    }
}
