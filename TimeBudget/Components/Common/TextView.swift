//
//  TextView.swift
//  TimeBudget
//
//  Created by Derrick Showers on 8/16/20.
//  Adapted from https://stackoverflow.com/questions/56471973/how-do-i-create-a-multiline-textfield-in-swiftui
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import Foundation
import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let myTextView = UITextView()
        myTextView.delegate = context.coordinator
        myTextView.backgroundColor = .clear
        myTextView.font = UIFont.preferredFont(forTextStyle: .body)
        return myTextView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView

        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
}
