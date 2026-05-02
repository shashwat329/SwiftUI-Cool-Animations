//
//  ViratAnimationVideo.swift
//  CoolAnimationInSwiftUI
//
//  Created by Kumar Shashwat on 02/05/26.
//

import SwiftUI

// MARK: - Color Extension
extension Color {
    static let rcbRed = Color(red: 0.8, green: 0.0, blue: 0.0)
    static let rcbDark = Color(red: 0.05, green: 0.0, blue: 0.0)
    static let rcbDeep = Color(red: 0.1, green: 0.0, blue: 0.0)
    static let rcbFire = Color(red: 1.0, green: 0.4, blue: 0.0)
}

struct RCBSplashView: View {

    @State private var burst = false
    @State private var showLogo = false
    @State private var showSlash = false
    @State private var showProfile = false

    var body: some View {
        ZStack {
            Color.rcbDark.ignoresSafeArea()

            // Aggressive diagonal slash
            if showSlash {
                Rectangle()
                    .fill(Color.rcbRed.opacity(0.15))
                    .rotationEffect(.degrees(-35))
                    .scaleEffect(x: 0.6, y: 3)
                    .offset(x: -40)
                    .transition(.opacity)
            }

            // Burst circle
            Circle()
                .fill(Color.rcbRed)
                .scaleEffect(burst ? 22 : 0.01)
                .animation(.easeOut(duration: 3.0), value: burst)

            // Ripple rings
            if showLogo {
                ForEach([0.8, 1.1, 1.45], id: \.self) { scale in
                    Circle()
                        .stroke(Color.rcbRed.opacity(0.25), lineWidth: 1)
                        .scaleEffect(scale)
                        .frame(width: 120, height: 120)
                }
            }

            // RCB logo
            if showLogo {
                VStack(spacing: 6) {
                    Image("Royal-Challengers-Bengaluru-Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 110)
                        .shadow(color: .rcbRed.opacity(0.8), radius: 20)
                        .transition(
                            .asymmetric(
                                insertion: .scale(scale: 0.4).combined(with: .opacity),
                                removal: .scale(scale: 1.6).combined(with: .opacity)
                            )
                        )
                    
                    Text("EE SALA CUP NAMDE")
                        .foregroundStyle(Color.white)
                        .font(.title2)
                        .fontDesign(.serif)
                        .bold()
                        .tracking(3)
                        .opacity(0.9)
                }
            }

            // Navigate to profile
            if showProfile {
                ViratAggressiveView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .opacity
                    ))
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
struct RCBStatBadge: View {
    let value: String
    let label: String
    let highlighted: Bool

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(highlighted ? Color.rcbFire : .white)
                .shadow(color: .black.opacity(0.5), radius: 2)

            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.75))
        }
        .frame(width: 105, height: 64)  // ← fixed size, not maxWidth: .infinity
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        highlighted
                            ? Color.rcbRed.opacity(0.25)
                            : Color.white.opacity(0.1)
                    )
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        highlighted ? Color.rcbRed.opacity(0.7) : Color.white.opacity(0.2),
                        lineWidth: highlighted ? 1 : 0.5
                    )
                if highlighted {
                    VStack {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.rcbRed)
                            .frame(height: 3)
                        Spacer()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
        )
    }
}


// MARK: - Virat Aggressive Profile
struct ViratAggressiveView: View {
    @State private var appeared = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Image("virat")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            
            Color.black.opacity(0.45)
                .ignoresSafeArea()
            Color.black.opacity(0.45)
                .ignoresSafeArea()
            LinearGradient(
                colors: [
                    Color.clear,
                    Color.black.opacity(0.6),
                    Color.black.opacity(0.88),
                    Color.black.opacity(0.97)
                ],
                startPoint: UnitPoint(x: 0.5, y: 0.6),
                endPoint: UnitPoint(x: 0.5, y: 1.0)
            )
            .ignoresSafeArea()
            VStack(spacing: 0) {
                VStack(spacing: 10) {
                    Capsule()
                        .fill(Color.rcbRed.opacity(0.25))
                        .overlay(Capsule().stroke(Color.rcbRed, lineWidth: 1))
                        .frame(width: 145, height: 28)
                        .overlay(
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color.rcbRed)
                                    .frame(width: 6, height: 6)
                                Text("LIVE · PLAYING XI")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(.white)
                                    .kerning(0.8)
                            }
                        )
                    Text("Virat Kohli")
                        .font(.system(size: 34, weight: .heavy))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.6), radius: 4, y: 2)
                    Text("India · No. 18 · Right-hand bat")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.75))   // ← was 0.5, now 0.75
                        .shadow(color: .black.opacity(0.8), radius: 3)
                    Capsule()
                        .fill(Color.rcbRed.opacity(0.3))
                        .overlay(Capsule().stroke(Color.rcbRed.opacity(0.7), lineWidth: 0.5))
                        .frame(width: 185, height: 24)
                        .overlay(
                            Text("KING KOHLI")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color.rcbFire)  // fully opaque now
                                .kerning(2)
                        )
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 18)
                .padding(.bottom, 22)
                
                HStack(spacing: 10) {
                    RCBStatBadge(value: "657",  label: "Runs",   highlighted: false)
                    RCBStatBadge(value: "54.75",  label: "Avg Score",  highlighted: true)
                    RCBStatBadge(value: "#3",  label: "rank",   highlighted: false)


                }
                .padding(.horizontal, 20)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 14)
                .padding(.bottom, 16)
                
                HStack(spacing: 12) {
                    Button("Follow") {}
                        .padding(.vertical, 16)
                        .padding(.horizontal,60)
                        .background(Color.rcbRed)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                        .cornerRadius(14)
                        .shadow(color: Color.rcbRed.opacity(0.7), radius: 14, y: 5)
                    
                    
                    Button("Stats") {}
                        .padding(.horizontal,70)
                        .padding(.vertical, 16)
                        .background(Color.white.opacity(0.12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.35), lineWidth: 1)
                        )
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .semibold))
                        .cornerRadius(14)
                }
                .padding(.horizontal, 20)
                .opacity(appeared ? 1 : 0)
                .padding(.bottom, 52)

            
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.7).delay(0.1)) {
                appeared = true
            }
        }
    }
}

// MARK: - Entry Point
struct RCBApp: View {
    var body: some View {
        RCBSplashView()
    }
}

#Preview { RCBApp() }
