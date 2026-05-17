//
//  DSGradientButton.swift
//  NutriSphere
//
//  Created by shashwat singh on 14/02/26.
//
import SwiftUI

struct DSGradientButton: View {
    
    let title: String
    let isEnabled: Bool
    let action: () -> Void
    
    @State private var pressed = false
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                Image(systemName: "arrow.right")
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.blue, Color.green],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(24)
            .scaleEffect(pressed ? 0.97 : 1)
            .opacity(isEnabled ? 1 : 0.5)
        }
        .disabled(!isEnabled)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded { _ in pressed = false }
        )
    }
}
