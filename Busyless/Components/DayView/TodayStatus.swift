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
        HStack {
            VStack {
                Text("Awake Time").font(Font.headline)
                Text(awakeDuration.hoursMinutesString).font(Font.caption)
            }
            Spacer()
            VStack {
                Text("Budgeted Time").font(Font.headline)
                Text(totalBudgetedDuration.hoursMinutesString).font(Font.caption)
            }
            Spacer()
            VStack {
                Text("Budgeted %").font(Font.headline)
                Text("\(String(format: "%.f", budgetedTimePercentage * 100))%").font(Font.caption)
            }
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
        .background(Color(UIColor.systemGray6))
    }
}

struct TodayStatus_Previews: PreviewProvider {
    static var previews: some View {
        TodayStatus(awakeDuration: 16 * TimeInterval.oneHour, totalBudgetedDuration: 8 * TimeInterval.oneHour)
    }
}
