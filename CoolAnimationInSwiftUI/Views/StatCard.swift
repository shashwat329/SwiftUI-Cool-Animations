//
//  StatCard.swift
//  CoolAnimationInSwiftUI
//
//  Created by Kumar Shashwat on 22/05/26.
//


import SwiftUI
 
// MARK: - Data Model
struct StatCard: Identifiable {
    let id = UUID()
    let value: String
    let label: String
    let icon: StatIcon
    let isHighlight: Bool
}
 
enum StatIcon {
    case arrowGreen
    case arrowDark
}
 
// MARK: - Main View
struct MarchSummaryView: View {
    @State private var animateCards = false
    @State private var animateScore = false
    @State private var scoreValue: Double = 0
 
    let stats: [StatCard] = [
        StatCard(
            value: "3/3",
            label: "Subjects passed",
            icon: .arrowGreen,
            isHighlight: true
        ),
        StatCard(value: "8/10", label: "Won matches",       icon: .arrowDark,  isHighlight: false),
        StatCard(value: "8/12", label: "Days running",      icon: .arrowDark,  isHighlight: false),
        StatCard(value: "22/24",label: "Completed tasks",   icon: .arrowGreen, isHighlight: true),
    ]
 
    var body: some View {
        ZStack {
            Color.neongreen
                .ignoresSafeArea()
 
            VStack(alignment: .leading, spacing: 0) {
 
                // MARK: Top Bar
                HStack {
                    // Avatar
                    Circle()
                        .fill(Color.black.opacity(0.15))
                        .frame(width: 42, height: 42)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.black.opacity(0.5))
                                .font(.system(size: 20))
                        )
 
                    Spacer()
 
                    // Bell
                    Circle()
                        .fill(Color.black)
                        .frame(width: 42, height: 42)
                        .overlay(
                            Image(systemName: "bell.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
 
                // MARK: Title
                VStack(alignment: .leading, spacing: 2) {
                    Text("March")
                    Text("summary")
                }
                .font(.system(size: 46, weight: .heavy, design: .default))
                .foregroundColor(.black)
                .padding(.horizontal, 20)
                .padding(.top, 28)
                .padding(.bottom, 28)
 
                // MARK: Stats Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                    ForEach(Array(stats.enumerated()), id: \.element.id) { index, stat in
                        StatCardView(stat: stat)
                            .opacity(animateCards ? 1 : 0)
                            .offset(y: animateCards ? 0 : 20)
                            .animation(
                                .spring(response: 0.5, dampingFraction: 0.75)
                                    .delay(Double(index) * 0.1),
                                value: animateCards
                            )
                    }
                }
                .padding(.horizontal, 20)
// 
                // MARK: Score Card
                ScoreCardView(score: scoreValue)
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .opacity(animateCards ? 1 : 0)
                    .offset(y: animateCards ? 0 : 20)
                    .animation(.spring(response: 0.5, dampingFraction: 0.75).delay(0.45), value: animateCards)
 
                Spacer()
 
                // MARK: Share Button
                Button(action: {}) {
                    Text("Share stats")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.black)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 36)
                .opacity(animateCards ? 1 : 0)
                .offset(y: animateCards ? 0 : 30)
                .animation(.spring(response: 0.5, dampingFraction: 0.75).delay(0.55), value: animateCards)
            }
        }
        .onAppear {
            animateCards = true
            withAnimation(.easeOut(duration: 1.4).delay(0.5)) {
                scoreValue = 74
            }
        }
    }
}
 
// MARK: - Stat Card
struct StatCardView: View {
    let stat: StatCard
 
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
 
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top) {
                    Text(stat.value)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
 
                    Spacer()
 
                    IconBadge(icon: stat.icon)
                }
 
                Text(stat.label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(16)
        }
        .frame(height: 100)
    }
}
 
// MARK: - Icon Badge
struct IconBadge: View {
    let icon: StatIcon
 
    var badgeColor: Color {
        switch icon {
        case .arrowGreen: return Color(hex: "#22C55E")
        case .arrowDark:  return Color.black
        }
    }
 
    var body: some View {
        Circle()
            .fill(badgeColor)
            .frame(width: 30, height: 30)
            .overlay(
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
            )
    }
}
 
// MARK: - Score Card
struct ScoreCardView: View {
    let score: Double
 
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
// 
            VStack(alignment: .leading, spacing: 4) {
                Text("\(Int(score))%")
                    .font(.system(size: 72, weight: .heavy, design: .default))
                    .foregroundColor(.black)
                    .contentTransition(.numericText())
                    .animation(.easeOut(duration: 1.2), value: score)
 
                Text("Score over 100%")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 130)
    }
}
 
// MARK: - Preview
#Preview {
    MarchSummaryView()
}
 
