//
//  TodayStatus.swift
//  Busyless
//
//  Created by Derrick Showers on 8/12/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct TodayStatus: View {

    // MARK: - Public Properties

    let awakeDuration: TimeInterval
    let totalBudgetedDuration: TimeInterval

    // MARK: - Private Properties

    private var budgetedTimePercentage: TimeInterval {
        return totalBudgetedDuration / awakeDuration
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
                Text(awakeDuration.hoursMinutesString)
            }.font(Font.caption.smallCaps())
            HStack {
                Text("Total time budgeted").foregroundColor(.white)
                Spacer()
                Text(totalBudgetedDuration.hoursMinutesString)
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
        .background(Color.mainColor.shadow(color: .black, radius: 3, x: 3, y: 3))

    }
}

struct TodayStatus_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TodayStatus(awakeDuration: 16 * TimeInterval.oneHour, totalBudgetedDuration: 16 * TimeInterval.oneHour).padding()
            TodayStatus(awakeDuration: 16 * TimeInterval.oneHour, totalBudgetedDuration: 8 * TimeInterval.oneHour).padding()
        }
    }
}
