//
//  Keyboard.swift
//  CoolAnimationInSwiftUI
//
//  Created by Kumar Shashwat on 16/05/26.
//



import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}
