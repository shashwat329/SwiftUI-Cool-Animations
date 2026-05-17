//
//  DSDateInputField.swift
//  NutriSphere
//
//  Created by shashwat singh on 15/02/26.
//


import SwiftUI

enum AgeGroup: String, CaseIterable, Identifiable, Codable{
    case zeroToSixMonths = "0 – 6 Months"
    case sixToTwelveMonths = "6 – 12 Months"
    case twelveToTwentyFourMonths = "12 – 24 Months"
    case twoToThreeYears = "2 – 3 Years"
    case threeToFiveYears = "3 – 5 Years"
    
    var id: String { rawValue }
}
struct DSAgeGroupInputField: View {
    
    let title: String
    @Binding var selectedAgeGroup: AgeGroup?
    var error: String?
    
    @State private var shake: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            DSSectionTitle(title: title)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(AgeGroup.allCases) { group in
                        ChipView(
                            title: group.rawValue,
                            isSelected: selectedAgeGroup == group
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedAgeGroup = group
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .offset(x: shake)
            .animation(.easeInOut(duration: 0.2), value: shake)
            
            if let error {
                Text(error)
                    .font(.system(size: 12))
                    .foregroundColor(DSColors.error)
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
}
struct ChipView: View {
    
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .medium))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? DSColors.primary.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isSelected ? DSColors.primary : Color.gray.opacity(0.3),
                        lineWidth: 1.5
                    )
            )
            .foregroundColor(isSelected ? DSColors.primary : .primary)
    }
}
