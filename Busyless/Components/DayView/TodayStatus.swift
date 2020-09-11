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
    let dailyBudgetPercentage: Double

    // MARK: - Private Properties

    @State private var showingDetailView = false

    private var budgetedTimePercentage: TimeInterval {
        return totalBudgetedDuration / awakeDuration
    }

    private var timeLeftToBudget: TimeInterval {
        let timeLeft = awakeDuration * dailyBudgetPercentage - totalBudgetedDuration
        return timeLeft < 0 ? 0 : timeLeft
    }

    // Budgeted Hours Left
    // Total Time Budgeted Today

    // MARK: - Lifecycle

    var body: some View {
        NavigationLink(destination: StatusDetailView(awakeDuration: awakeDuration,
                                                     totalBudgetedDuration: totalBudgetedDuration,
                                                     dailyBudgetPercentage: dailyBudgetPercentage),
                       isActive: $showingDetailView) {
            VStack(alignment: .leading) {
                Text("Today's Status")
                    .font(Font.headline.lowercaseSmallCaps())
                    .padding(.bottom, 10)
                HStack {
                    Text("Total Time Budgeted").foregroundColor(.white)
                    Spacer()
                    Text(totalBudgetedDuration.hoursMinutesString)
                }.font(Font.callout.lowercaseSmallCaps())
                HStack {
                    Text("Available Time To Be Budgeted")
                    Spacer()
                    Text(timeLeftToBudget.hoursMinutesString)
                }.font(Font.callout.lowercaseSmallCaps())
                Text("Tap for more details")
                    .font(Font.footnote.italic())
                    .padding(.top, 20)
            }
        }
        .foregroundColor(.white)
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
        .background(Color.mainColor.shadow(color: .gray, radius: 3, x: 0, y: 2))
    }
}

struct StatusDetailView: View {

    // MARK: - Public Properties

    let awakeDuration: TimeInterval
    let totalBudgetedDuration: TimeInterval
    let dailyBudgetPercentage: Double

    // MARK: - Private Properties

    private var budgetedTimePercentage: TimeInterval {
        return totalBudgetedDuration / awakeDuration
    }

    // MARK: - Lifecycle

    var body: some View {
        VStack(alignment: .leading) {
            Text("Work in progress. Check back for more soon!")
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
            HStack {
                Text("Target daily budget percentage")
                Spacer()
                Text("\(String(format: "%.f", dailyBudgetPercentage * 100))%")
            }.font(Font.caption.smallCaps())
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.horizontal, 20)
        .background(Color.mainColor.shadow(color: .black, radius: 3, x: 3, y: 3).edgesIgnoringSafeArea(.all))
    }
}

struct TodayStatus_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TodayStatus(awakeDuration: 16 * TimeInterval.oneHour, totalBudgetedDuration: 16 * TimeInterval.oneHour, dailyBudgetPercentage: 50).padding()
            TodayStatus(awakeDuration: 16 * TimeInterval.oneHour, totalBudgetedDuration: 8 * TimeInterval.oneHour, dailyBudgetPercentage: 50).padding()
        }
    }
}
