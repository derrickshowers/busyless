//
//  CategoryDetailView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/17/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import BusylessDataLayer

struct CategoryDetailView: View {

    // MARK: - Constants

    static let durationSliderHeight: CGFloat = 325

    // MARK: - Public Properties

    let category: BLCategory
    let overviewType: OverviewType

    // MARK: - Private Properties

    @State private var showingAddNewActivityView = false
    @State private var duration: TimeInterval

    @Environment(\.presentationMode)
    private var presentationMode

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    private var activities: [Activity] {
        guard let activities = category.activities?.allObjects as? [Activity] else {
            return []
        }

        if overviewType == .month {
            return activities.filter(byMonth: Calendar.current.component(.month, from: Date()))
        }

        return activities.filter(byDate: Date())
    }

    private var timeLeftInCurrentCategory: TimeInterval {
        return duration - activities.map({$0.duration}).reduce(0, +)
    }

    // MARK: - Lifecycle

    init(category: BLCategory, overviewType: OverviewType) {
        self.category = category
        self.overviewType = overviewType
        _duration = State(initialValue: category.dailyBudgetDuration)
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    if overviewType == .day {
                        HStack {
                            DurationSlider(duration: $duration, maxDuration: 8 * TimeInterval.oneHour)
                                .frame(maxWidth: CategoryDetailView.durationSliderHeight,
                                       minHeight: CategoryDetailView.durationSliderHeight,
                                       maxHeight: CategoryDetailView.durationSliderHeight)
                                .padding(.vertical, 10)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.customWhite)
                    }

                    VStack(spacing: 15) {
                        HStack {
                            Text("Time spent")
                            Spacer()
                            if overviewType == .day {
                                Text(category.timeSpentToday.hoursMinutesString).bold()
                            } else {
                                Text(category.timeSpentThisMonth.hoursMinutesString).bold()
                            }

                        }
                        if overviewType == .day {
                            Divider()
                            HStack {
                                Text("Time available to budget")
                                Spacer()
                                Text("Unknown").bold()
                            }
                            Divider()
                            HStack {
                                Text("Time left in \(category.name?.lowercased() ?? "category")")
                                Spacer()
                                Text(abs(timeLeftInCurrentCategory).hoursMinutesString)
                                    .foregroundColor(timeLeftInCurrentCategory >= 0 ? Color(UIColor.label) : Color.red)
                                    .bold()
                            }
                        }
                    }
                    .padding(15)
                    .background(Color.customWhite)

                    HStack {
                        Text("Logged Activities")
                            .font(Font.headline.smallCaps())
                        Spacer()
                    }.padding(15)

                    HStack {
                        if activities.count > 0 {
                            VStack(spacing: 15) {
                                ForEach(activities, id: \.self) { (activity: Activity) in
                                    HStack {
                                        Text(activity.name ?? "")
                                            .font(.body)
                                        Spacer()
                                        Text(activity.duration.hoursMinutesString)
                                            .font(.caption)
                                    }
                                }
                            }
                            .padding(.horizontal, 15)
                        } else {
                            VStack {
                                Text("No logged activities for this category")
                                    .font(.caption)
                                    .foregroundColor(Color(UIColor.placeholderText))
                            }
                            .padding(.horizontal, 15)
                        }
                    }.padding(.bottom, 150)
                }
            }
            .background(Color(UIColor.systemGray6))
            .edgesIgnoringSafeArea(.bottom)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddButton {
                        self.showingAddNewActivityView.toggle()
                    }
                }
            }
        }
        .navigationBarTitle(category.name ?? "Category Detail")
        .onDisappear {
            self.category.dailyBudgetDuration = duration
            BLCategory.save(with: self.managedObjectContext)

        }
        .sheet(isPresented: $showingAddNewActivityView) {
            AddNewActivityView(isPresented: self.$showingAddNewActivityView, preselectedCategory: self.category)
                .environment(\.managedObjectContext, self.managedObjectContext)
        }
    }
}

extension CategoryDetailView {
    enum OverviewType {
        case day
        case month
    }
}

struct CategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CategoryDetailView(category: BLCategory.mockCategory(), overviewType: .day)
            CategoryDetailView(category: BLCategory.mockCategory(), overviewType: .day)
                .environment(\.colorScheme, .dark)
        }
        Group {
            CategoryDetailView(category: BLCategory.mockCategory(), overviewType: .month)
            CategoryDetailView(category: BLCategory.mockCategory(), overviewType: .month)
                .environment(\.colorScheme, .dark)
        }
    }
}
