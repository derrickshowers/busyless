//
//  ActionBar.swift
//  Busyless
//
//  Created by Derrick Showers on 1/15/22.
//  Copyright © 2022 Derrick Showers. All rights reserved.
//

import Foundation
import SwiftUI

struct ActionBar: View {
    let onDelete: () -> Void
    let onEditCategory: () -> Void
    let onRoundTime: () -> Void
    let onCancel: () -> Void
    var body: some View {
        HStack {
            Button {
                onDelete()
            } label: {
                VStack {
                    Image(systemName: "trash.fill")
                    Spacer()
                    Text("Delete").font(.caption2)
                }
            }
            Spacer()
            Button {
                onEditCategory()
            } label: {
                VStack {
                    Image(systemName: "arrow.up.bin.fill")
                    Spacer()
                    Text("Edit Category").font(.caption2)
                }
            }
            Spacer()
            Button {
                onRoundTime()
            } label: {
                VStack {
                    Image(systemName: "clock.badge.checkmark.fill")
                    Spacer()
                    Text("Round Time").font(.caption2)
                }
            }
            Spacer()
            Button {
                onCancel()
            } label: {
                VStack {
                    Image(systemName: "multiply.circle.fill")
                    Spacer()
                    Text("Cancel").font(.caption2)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .foregroundColor(.white)
        .background(Color.mainColor)
        .frame(maxHeight: 50)
    }
}

struct ActionBar_Previews: PreviewProvider {
    static var previews: some View {
        let actionbar = ActionBar {} onEditCategory: {} onRoundTime: {} onCancel: {}
        return Group {
            actionbar
            actionbar.environment(\.colorScheme, .dark)
        }
        .previewLayout(.sizeThatFits)
    }
}
