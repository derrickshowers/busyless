//
//  OnboardingShell.swift
//  Busyless
//
//  Created by Derrick Showers on 12/29/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct OnboardingShell<Content>: View where Content: View {

    // MARK: - Public Properties

    let content: Content

    // MARK: - Private Properties

    @Environment(\.presentationMode)
    private var presentationMode

    // MARK: - Lifecycle

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            ZStack {
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(Color.secondaryColor)
                        .ignoresSafeArea(edges: .bottom)
                        .frame(maxHeight: 60)

                }
                TabView {
                    content
                }
                .tabViewStyle(PageTabViewStyle())
            }
            VStack {
                HStack {
                    Spacer()
                    Button("Skip") { presentationMode.wrappedValue.dismiss() }
                }.padding(25)
                Spacer()
            }
        }.background(Color(UIColor.systemBackground))
    }
}

struct OnboardingShell_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingShell { }
    }
}
