//
//  DSInputField.swift
//  NutriSphere
//
//  Created by shashwat singh on 14/02/26.
//

import SwiftUI

struct DSInputField: View {
    
    let title: String
    let placeholder: String
    
    @Binding var text: String
    
    var error: String?
    var keyboard: UIKeyboardType = .default
    var trailing: String? = nil
    
    @FocusState private var isFocused: Bool
    @State private var shake: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            DSSectionTitle(title: title)
            
            HStack {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboard)
                        .focused($isFocused)
                
                
                if let trailing {
                    Text(trailing)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(DSColors.inputBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(borderColor, lineWidth: 1.5)
            )
            .cornerRadius(18)
            .offset(x: shake)
            .animation(.easeInOut(duration: 0.2), value: shake)
            
            if let error {
                Text(error)
                    .font(.system(size: 12))
                    .foregroundColor(DSColors.error)
                    .transition(.opacity)
            }
        }
        .onChange(of: error) { newValue in
            if newValue != nil {
                triggerShake()
            }
        }
    }
    
    private func triggerShake() {
        withAnimation { shake = -8 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            shake = 8
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            shake = 0
        }
    }
    
    private var borderColor: Color {
        if error != nil { return DSColors.error }
        return isFocused ? DSColors.primary : Color.gray.opacity(0.3)
    }
}
