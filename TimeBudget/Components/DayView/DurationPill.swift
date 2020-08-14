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

    @Binding var dailyBudgetDuration: Int16

    let timeSpentDuration: Int

    // MARK: - Private Properties

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
                TextField("\(dailyBudgetDuration)", value: $dailyBudgetDuration, formatter: NumberFormatter()) {
                    self.isEditing.toggle()
                    Category.save(with: self.managedObjectContext)
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
            DurationPill(dailyBudgetDuration: .constant(5), timeSpentDuration: 5).padding()
            DurationPill(dailyBudgetDuration: .constant(5), timeSpentDuration: 6).padding()
        }
    }
}
