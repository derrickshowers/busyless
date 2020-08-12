//
//  MainView.swift
//  TimeBudget
//
//  Created by Derrick Showers on 8/12/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State private var isDayViewActive = true

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: DayView(), isActive: $isDayViewActive) {
                    Text("Today")
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .onAppear {
                UITableView.appearance().separatorStyle = .none
            }
            DayView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return MainView().environment(\.managedObjectContext, context)
    }
}
