//
//  AddButton.swift
//  Busyless
//
//  Created by Derrick Showers on 8/10/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct AddButton: View {

    // MARK: - Public Properties

    let action: (() -> Void)

    // MARK: - Lifecycle

    var body: some View {
        Button(action: self.action, label: {
            Text("+")
                .padding(.bottom, 4)
                .accessibility(label: Text("Add a new activity"))
                .font(.system(.largeTitle))
                .foregroundColor(Color.white)

        })
            .frame(width: 50, height: 50)
            .background(Color.mainColor)
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
