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
    let onCancel: () -> Void
    var body: some View {
        HStack {
            Button {
                onDelete()
            } label: {
                Text("Delete")
            }
            Button {
                onEditCategory()
            } label: {
                Text("Edit Category")
            }
            Button {
                onCancel()
            } label: {
                Text("Cancel")
            }
        }
    }
}
