//
//  PlayerProfile.swift
//  CoolAnimationInSwiftUI
//
//  Created by Kumar Shashwat on 09/05/26.
//


import SwiftUI

// MARK: - Reusable Player Model
struct PlayerProfile {
    let playerName: String
    let subtitle: String
    let tagline: String
    let warcry: String
    let backgroundImage: String
    let logoImage: String

    let primaryColor: Color
    let accentColor: Color

    let stats: [PlayerStat]
}

struct PlayerStat: Identifiable {
    let id = UUID()
    let value: String
    let label: String
    let highlighted: Bool
}

// MARK: - Reusable Splash + Profile Screen
struct PlayerSplashView: View {

    let profile: PlayerProfile

    @State private var burst = false
    @State private var showLogo = false
    @State private var showSlash = false
    @State private var showProfile = false

    var body: some View {
        ZStack {
            profile.primaryColor.ignoresSafeArea()
            
            if showSlash {
                Rectangle()
                    .fill(profile.accentColor.opacity(0.15))
                    .rotationEffect(.degrees(-35))
                    .scaleEffect(x: 0.6, y: 3)
                    .offset(x: -40)
                    .transition(.opacity)
            }
            
            Circle()
                .fill(profile.accentColor.opacity(0.5))
                .scaleEffect(burst ? 22 : 0.01)
                .animation(.easeOut(duration: 3.0), value: burst)
            
            if showLogo {
                ForEach([0.8, 1.1, 1.45], id: \.self) { scale in
                    Circle()
                        .stroke(profile.accentColor.opacity(0.25), lineWidth: 1)
                        .scaleEffect(scale)
                        .frame(width: 120, height: 120)
                }
            }
            if showLogo {
                VStack(spacing: 6) {
                    
                    Image(profile.logoImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 220, height: 110)
                        .shadow(color: profile.accentColor.opacity(0.8), radius: 20)
                    
                    Text(profile.warcry)
                        .foregroundStyle(Color.white)
                        .font(.title2)
                        .fontDesign(.serif)
                        .bold()
                        .tracking(3)
                        .opacity(0.9)
                        .padding(.vertical)
                }
                
            }
//             Main Profile
            if showProfile {
                PlayerProfileView(profile: profile)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .trailing)
                                .combined(with: .opacity),
                            removal: .opacity
                        )
                    )
            }

        }
        .onAppear {

            burst = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.65)) {
                    showLogo = true
                    showSlash = true
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation(.easeIn(duration: 0.3)) {
                    showLogo = false
                    showSlash = false
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                    showProfile = true
                }
            }
        }
    }
}

// MARK: - Profile Screen
struct PlayerProfileView: View {

    let profile: PlayerProfile

    @State private var appeared = false

    var body: some View {

        ZStack(alignment: .bottom) {
            Image(profile.backgroundImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            

            Color.black.opacity(0.45)
                .ignoresSafeArea()

            LinearGradient(
                colors: [
                    .clear,
                    .black.opacity(0.6),
                    .black.opacity(0.88),
                    .black.opacity(0.97)
                ],
                startPoint: .init(x: 0.5, y: 0.6),
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: Header
                VStack(spacing: 10) {

                    
                    Capsule()
                        .fill(profile.accentColor.opacity(0.25))
                        .overlay(
                            Capsule()
                                .stroke(profile.accentColor, lineWidth: 1)
                        )
                        .frame(width: 145, height: 28)
                        .overlay(
                            HStack(spacing: 6) {

                                Circle()
                                    .fill(profile.accentColor)
                                    .frame(width: 6, height: 6)

                                Text("LIVE · PLAYING XI")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        )
                    
                    
                    
                    Text(profile.playerName)
                        .font(.system(size: 34, weight: .heavy))
                        .foregroundColor(.white)
                    
                    
                    
                    Text(profile.subtitle)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.75))
                    Capsule()
                        .fill(profile.accentColor.opacity(0.3))
                        .overlay(
                            Capsule()
                                .stroke(profile.accentColor.opacity(0.7))
                        )
                        .frame(width: 190, height: 24)
                        .overlay(
                            Text(profile.tagline)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(profile.accentColor)
                                .kerning(2)
                        )

                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 18)
                .padding(.bottom, 22)

                // MARK: Stats
                HStack(spacing: 10) {

                    ForEach(profile.stats) { stat in

                        StatBadge(
                            value: stat.value,
                            label: stat.label,
                            highlighted: stat.highlighted,
                            accentColor: profile.accentColor
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)

                // MARK: Buttons
                HStack(spacing: 12) {
                    
                    
                    Button("Follow") {

                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 60)
                    .background(profile.accentColor)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .cornerRadius(14)
                    
                    
                    Button("Stats") {

                    }
                    .padding(.horizontal, 70)
                    .padding(.vertical, 16)
                  .background(Color.white.opacity(0.12))
                  .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white.opacity(0.35))
                    )
                    .foregroundColor(.white)

                }
                .padding(.bottom, 52)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) {
                appeared = true
            }
        }
    }
}

// MARK: - Reusable Stat Badge
struct StatBadge: View {

    let value: String
    let label: String
    let highlighted: Bool
    let accentColor: Color

    var body: some View {

        VStack(spacing: 4) {

            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(highlighted ? accentColor : .white)

            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.75))
        }
        .frame(width: 105, height: 64)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    highlighted
                    ? accentColor.opacity(0.25)
                    : Color.white.opacity(0.08)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    highlighted
                    ? accentColor
                    : Color.white.opacity(0.2)
                )
        )
    }
}
struct VaibhavApp: View {

    let vaibhav = PlayerProfile(
        playerName: "Vaibhav Suryavanshi",
        subtitle: "India · No. 9 · left-hand bat",
        tagline: "TEEN SENSATION",
        warcry: "royal hain Wo",

        backgroundImage: "vaibhav",
        logoImage: "rrlogo",

        primaryColor: Color(red: 1.0, green: 0.18, blue: 0.50),
        accentColor: .pink,

        stats: [
            PlayerStat(value: "404", label: "Runs", highlighted: false),
            PlayerStat(value: "1", label: "Century", highlighted: true),
            PlayerStat(value: "40.40", label: "Avg", highlighted: false),
            
        ]
    )

    var body: some View {

        PlayerSplashView(profile: vaibhav)
    }
}

#Preview {
    VaibhavApp()
}



