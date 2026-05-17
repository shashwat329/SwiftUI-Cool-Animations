//
//  DSGenderSelector.swift
//  NutriSphere
//
//  Created by shashwat singh on 14/02/26.
//

import SwiftUI
struct DSGenderSelector: View {
    
    @Binding var selected: ChildProfileViewModel.Gender
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DSSectionTitle(title: "Gender")
            
            HStack(spacing: 16) {
                ForEach(ChildProfileViewModel.Gender.allCases, id: \.self) { gender in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            selected = gender
                        }
                    } label: {
                        Text(gender.rawValue)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(selected == gender ? .blue : .gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(selected == gender ? Color.blue.opacity(0.1) : .white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(selected == gender ? .blue : .gray.opacity(0.3), lineWidth: 1.5)
                            )
                            .scaleEffect(selected == gender ? 1.05 : 1)
                    }
                }
            }
        }
    }
}
