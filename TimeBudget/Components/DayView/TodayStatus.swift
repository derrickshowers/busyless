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

    // MARK: - Lifecycle

    var body: some View {
        VStack(alignment: .leading) {
            Text("Today's Status")
                .font(Font.headline.lowercaseSmallCaps())
                .padding(.bottom, 10)
            HStack {
                Text("Total Time Awake")
                Spacer()
                Text("\(awakeDuration) hr(s)")
            }.font(Font.caption.smallCaps())
            HStack {
                Text("Total time budgeted").foregroundColor(.white)
                Spacer()
                Text("\(totalBudgetedDuration) hr(s)")
            }.font(Font.caption.smallCaps())
            HStack {
                Text("Percentage of awake time budgeted")
                Spacer()
                Text("\(String(format: "%.f", budgetedTimePercentage * 100))%")
            }.font(Font.caption.smallCaps())
        }
        .foregroundColor(.white)
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
        .background(Color.blue.shadow(color: .gray, radius: 3, x: 0, y: 2))

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
