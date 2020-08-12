//
//  TodayStatus.swift
//  TimeBudget
//
//  Created by Derrick Showers on 8/12/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct TodayStatus: View {

    // MARK: - Public Properties
    let awakeDuration: Int
    let totalBudgetedDuration: Int

    // MARK: - Private Properties
    private var budgetedTimePercentage: Double {
        return Double(totalBudgetedDuration) / Double(awakeDuration)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Today's Status")
                .font(.headline).foregroundColor(.white)
                .padding(.bottom, 10)
            HStack {
                Text("Total time awake")
                Spacer()
                Text("\(awakeDuration) hr(s)")
            }.font(.caption).foregroundColor(.white)
            HStack {
                Text("Total time budgeted").foregroundColor(.white)
                Spacer()
                Text("\(totalBudgetedDuration) hr(s)")
            }.font(.caption).foregroundColor(.white)
            HStack {
                Text("Percentage of time budgeted")
                    .foregroundColor(.white)
                Spacer()
                Text("\(String(format: "%.f", budgetedTimePercentage * 100))%")
                    .foregroundColor(budgetedTimePercentage > 1 ? .red : .white)
            }.font(.caption)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(Color.blue)

    }
}

struct TodayStatus_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TodayStatus(awakeDuration: 16, totalBudgetedDuration: 8).padding()
            TodayStatus(awakeDuration: 16, totalBudgetedDuration: 17).padding()
        }
    }
}
