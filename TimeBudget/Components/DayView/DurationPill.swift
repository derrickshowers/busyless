//
//  DurationPill.swift
//  TimeBudget
//
//  Created by Derrick Showers on 8/10/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct DurationPill: View {

    // MARK: - Public Properties

    @Binding var dailyBudgetDuration: TimeInterval

    let timeSpentDuration: TimeInterval

    // MARK: - Private Properties

    @State private var newDailyBudgetDuration = ""
    @State private var isEditing = false

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    private var backgroundColor: Color {
        if timeSpentDuration <= dailyBudgetDuration {
            return Color.green
        } else {
            return Color.red
        }
    }

    // MARK: - Lifecycle

    var body: some View {
        HStack {
            if isEditing {
                HStack(spacing: 0) {
                    TextField("", text: $newDailyBudgetDuration) {
                        self.dailyBudgetDuration = (TimeInterval(self.newDailyBudgetDuration) ?? 0) * 3600
                        self.isEditing.toggle()
                        Category.save(with: self.managedObjectContext)
                    }
                    .fixedSize()
                    Text("hr")
                }
                .padding(5)
                .padding(.horizontal, 10)
                .font(Font.caption.bold())
                .multilineTextAlignment(.center)
                .foregroundColor(Color.white)
                .background(Color.gray)
                .cornerRadius(20)
            } else {
                Text("\(timeSpentDuration.hoursMinutesString) / \(dailyBudgetDuration.hoursMinutesString)")
                    .padding(5)
                    .padding(.horizontal, 10)
                    .font(Font.caption.bold())
                    .foregroundColor(Color.white)
                    .background(backgroundColor)
                    .cornerRadius(20)
                    .onTapGesture {
                        self.isEditing.toggle()
                }
            }
        }
    }
}

struct DurationPill_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DurationPill(dailyBudgetDuration: .constant(TimeInterval.oneHour), timeSpentDuration: TimeInterval.oneHour).padding()
        }
    }
}
