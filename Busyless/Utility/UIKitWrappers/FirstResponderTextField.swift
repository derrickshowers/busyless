//
//  FirstResponderTextField.swift
//  Busyless
//
//  Created by Derrick Showers on 10/13/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import UIKit
import SwiftUI

struct FirstResponderTextField: UIViewRepresentable {
    private var placeholder: String
    private var onCommit: (() -> Void)?
    @Binding private var text: String
    @Binding private var isFirstResponder: Bool

    init(_ placeholder: String, text: Binding<String>, isFirstResponder: Binding<Bool>, onCommit: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self._text = text
        self._isFirstResponder = isFirstResponder
        self.onCommit = onCommit
    }

    func makeUIView(context: UIViewRepresentableContext<FirstResponderTextField>) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<FirstResponderTextField>) {
        uiView.placeholder = placeholder
        uiView.text = text

        if isFirstResponder {
            uiView.becomeFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var firstResponderTextField: FirstResponderTextField

        init(_ firstResponderTextField: FirstResponderTextField) {
            self.firstResponderTextField = firstResponderTextField
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            firstResponderTextField.text = textField.text ?? ""
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            firstResponderTextField.text = textField.text ?? ""
            firstResponderTextField.onCommit?()
            return true
        }
    }
}
