//
//  OnboardingContent.swift
//  Busyless
//
//  Created by Derrick Showers on 12/29/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct OnboardingContent: View {

    // MARK: - Private Properties

    @Environment(\.presentationMode)
    private var presentationMode

    // MARK: - Public Properties

    let imageName: String
    let headline: String
    let summary: LocalizedStringKey
    var isLogo = false
    var dismissButtonText: String?

    // MARK: - Lifecycle

    var body: some View {
        VStack {
            if isLogo {
                Image(imageName)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .cornerRadius(25)
                    .padding(.bottom, 30)
            } else {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 200)
                    .padding(.bottom, 30)
            }
            Text(headline)
                .foregroundColor(Color.mainColor)
                .font(.title)
                .bold()
            Rectangle()
                .fill(Color.mainColor)
                .frame(maxWidth: 75, maxHeight: 1)
                .padding(.bottom, 15)
            Text(summary)
                .font(.callout)
            if let buttonText = dismissButtonText {
                Button(buttonText) { presentationMode.wrappedValue.dismiss() }
                    .padding(.top, 30)
            }
        }
    }
}

struct OnboardingContent_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingContent(imageName: "LogoWithBackground",
                              headline: "Headline",
                              summary: "Summary",
                              isLogo: true)
            OnboardingContent(imageName: "WorkTime",
                              headline: "Headline",
                              summary: "Summary")
        }

    }
}
