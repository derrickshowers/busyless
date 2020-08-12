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
    let timeSpentDuration: Int
    @Binding var dailyBudgetDuration: Int16

    // MARK: - Private Properties
    @Environment(\.managedObjectContext) private var managedObjectContext
    @State private var isEditing = false
    private var backgroundColor: Color {
        if timeSpentDuration <= dailyBudgetDuration {
            return Color.green
        } else {
            return Color.red
        }
    }

    var body: some View {
        HStack {
            if isEditing {
                TextField("\(dailyBudgetDuration)", value: $dailyBudgetDuration, formatter: NumberFormatter()) {
                    self.isEditing.toggle()
                    try? self.managedObjectContext.save()
                }
                .padding(5)
                .padding(.horizontal, 10)
                .font(Font.caption.bold())
                .multilineTextAlignment(.center)
                .foregroundColor(Color.white)
                .background(Color.gray)
                .cornerRadius(20)
                .fixedSize()
            } else {
                Text("\(timeSpentDuration) / \(dailyBudgetDuration) hr(s)")
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
            DurationPill(timeSpentDuration: 5, dailyBudgetDuration: .constant(5)).padding()
            DurationPill(timeSpentDuration: 6, dailyBudgetDuration: .constant(5)).padding()
        }
    }
}
