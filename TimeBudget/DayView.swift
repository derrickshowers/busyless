//
//  DayView.swift
//  TimeBudget
//
//  Created by Derrick Showers on 8/8/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

// TODO: Move this to its own file.
struct Category: Identifiable {
    let id: Int
    let name: String
    let budgetAmount: Int
}

struct DayView: View {
    @State var showingAddNewActivity = false

    // TODO: Temporary will come from db
    // TODO: Need an ID? Or can it be derived from name?
    var categories = [
        Category(id: 0, name: "Coding", budgetAmount: 3),
        Category(id: 1, name: "Meetings", budgetAmount: 3),
        Category(id: 2, name: "Emails", budgetAmount: 1),
        Category(id: 3, name: "Learning", budgetAmount: 1),
        Category(id: 4, name: "Meditation", budgetAmount: 1),
        Category(id: 5, name: "Journaling", budgetAmount: 1),
        Category(id: 6, name: "Family Time", budgetAmount: 4)
    ]

    var body: some View {
        NavigationView {
            VStack {
                List(categories) { category in
                    HStack {
                        Text(category.name)
                        Spacer()
                        Text("\(category.budgetAmount) hr")
                            .padding(5)
                            .padding(.leading, 15)
                            .padding(.trailing, 15)
                            .foregroundColor(Color.white)
                            .background(Color.green)
                            .cornerRadius(20)
                    }
                }
                .onAppear() {
                    UITableView.appearance().separatorStyle = .none
                }
                HStack {
                    Spacer()
                    Button(action: {
                        self.showingAddNewActivity.toggle()
                    }, label: {
                        Text("+")
                            .accessibility(label: Text("Add a new activity"))
                            .font(.system(.largeTitle))
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.white)
                    })
                        .background(Color.blue)
                        .cornerRadius(25)
                        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                        .padding()
                        .sheet(isPresented: $showingAddNewActivity) {
                            AddNewActivityView()
                    }
                }
            }
            .navigationBarTitle("Today")
        }
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView()
    }
}
