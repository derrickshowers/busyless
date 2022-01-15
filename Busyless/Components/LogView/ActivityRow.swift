//
//  ActivityRow.swift
//  Busyless
//
//  Created by Derrick Showers on 1/15/22.
//  Copyright © 2022 Derrick Showers. All rights reserved.
//

import Foundation
import SwiftUI
import BusylessDataLayer

struct ActivityRow: View {
    let activity: Activity
    let action: () -> Void

    var body: some View {
        Button(action: { action() }, label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(activity.name ?? "")
                        .foregroundColor(Color.primary)
                        .font(.subheadline)
                    Text(activity.category?.name ?? "Uncategorized")
                        .font(.caption2)
                        .foregroundColor(Color.gray)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(activity.duration.hoursMinutesString)
                        .foregroundColor(Color.primary)
                        .font(.subheadline)
                    if let time = activity.createdAt?.prettyTime {
                        Text(time)
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
        }).padding(.vertical, 5)
    }
}
