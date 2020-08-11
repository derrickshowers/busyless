//
//  AddButton.swift
//  TimeBudget
//
//  Created by Derrick Showers on 8/10/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct AddButton: View {
    let action: (() -> Void)

    var body: some View {
        Button(action: self.action, label: {
            Text("+")
                .accessibility(label: Text("Add a new activity"))
                .font(.system(.largeTitle))
                .foregroundColor(Color.white)

        })
            .frame(width: 50, height: 50)
            .background(Color.blue)
            .clipShape(Circle())
            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
            .padding()
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton {}
    }
}
