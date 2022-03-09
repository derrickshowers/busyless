//
//  DurationPill.swift
//  Busyless
//
//  Created by Derrick Showers on 8/10/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct DurationPill: View {
    // MARK: - Public Properties

    let dailyBudgetDuration: TimeInterval
    let timeSpentDuration: TimeInterval

    // MARK: - Private Properties

    private var backgroundColor: Color {
        if timeSpentDuration < dailyBudgetDuration {
            return Color.green
        } else if timeSpentDuration == dailyBudgetDuration {
            return Color.gray
        } else {
            return Color.red
        }
    }

    private var timeRemaining: TimeInterval {
        return abs(dailyBudgetDuration - timeSpentDuration)
    }

    // MARK: - Lifecycle

    var body: some View {
        Text(timeRemaining.hoursMinutesString)
            .padding(5)
            .padding(.horizontal, 10)
            .font(Font.caption.bold())
            .foregroundColor(Color.white)
            .background(backgroundColor)
            .cornerRadius(20)
    }
}

struct DurationPill_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DurationPill(
                dailyBudgetDuration: TimeInterval.oneHour,
                timeSpentDuration: TimeInterval.oneHour
            ).padding()
            DurationPill(
                dailyBudgetDuration: TimeInterval.oneHour,
                timeSpentDuration: TimeInterval.oneHour * 2
            ).padding()
            DurationPill(
                dailyBudgetDuration: TimeInterval.oneHour * 2,
                timeSpentDuration: TimeInterval.oneHour
            ).padding()
        }
    }
}
