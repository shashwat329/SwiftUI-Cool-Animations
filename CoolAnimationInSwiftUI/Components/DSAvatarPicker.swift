//
//  DSAvatarPicker.swift
//  NutriSphere
//
//  Created by shashwat singh on 14/02/26.
//

import SwiftUI


struct DSAvatarPicker: View {
    let avatars: [String] = ["whitegirl", "blackgirl", "whiteKid", "blackboy"]
    @Binding var selectedIndex: Int
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Choose an avatar")
                .font(.system(size: 18, weight: .semibold))
            
            HStack(spacing: 18) {
                ForEach(avatars.indices, id: \.self) { index in
                    let avatar = avatars[index]
                    
                    ZStack(alignment: .bottomTrailing) {
                        
                        Image(avatar)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 72, height: 72)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(
                                        selectedIndex == index ? Color.blue : Color.clear,
                                        lineWidth: 3
                                    )
                            )
                            .scaleEffect(selectedIndex == index ? 1.1 : 1)
                            .animation(
                                .spring(response: 0.3, dampingFraction: 0.6),
                                value: selectedIndex
                            )
                        
                        if selectedIndex == index {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 22, height: 22)
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                )
                                .transition(.scale)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            selectedIndex = index
                        }
                    }
                }
            }
        }
    }
}
