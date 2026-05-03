//
//  VaibhavView.swift
//  CoolAnimationInSwiftUI
//
//  Created by Kumar Shashwat on 03/05/26.
//
import SwiftUI
 
// MARK: - VaibhavView
// A cinematic story: Baby → Twister Transformation → Grown Man (Age 100)
 
struct VaibhavView: View {
 
    // MARK: - Animation State
    @State private var showBaby: Bool = false
    @State private var showTwister: Bool = false
    @State private var babyScale: CGFloat = 0.3
    @State private var babyOpacity: Double = 0
    @State private var twistedOpacity: Double = 0
    @State private var twistedScale: CGFloat = 0.5
    @State private var showMan: Bool = false
    @State private var manOpacity: Double = 0
    @State private var manScale: CGFloat = 0.7
    @State private var ageTextOpacity: Double = 0
    @State private var ageTextScale: CGFloat = 0.5
    @State private var bgPulse: Bool = false
    @State private var glowRadius: CGFloat = 0
    @State private var particleOffset: CGFloat = 0
 
    // MARK: - Body
    var body: some View {
        ZStack {
 
            // ─── Background ───────────────────────────────────────────────
            backgroundLayer
 
            // ─── Floating sparkle particles ───────────────────────────────
            particleLayer
 
            // ─── Story Layers ─────────────────────────────────────────────
            VStack(spacing: 0) {
 
                Spacer()
 
                // Phase 1 — Baby
                if showBaby {
                    babyLayer
                }
 
                // Phase 2 — Twister spinning around baby
                if showTwister {
                    twistedLayer
                }
 
                // Phase 3 — Grown man with bold "100"
                if showMan {
                    manLayer
                }
 
                Spacer()
            }
        }
        .ignoresSafeArea()
        .onAppear { startStory() }
    }
 
    // MARK: - Background
    private var backgroundLayer: some View {
        ZStack {
            // Deep pink base
            Color(red: 1.0, green: 0.18, blue: 0.50)
                .ignoresSafeArea()
 
            // Radial glow that pulses during twister phase
            RadialGradient(
                colors: [
                    Color.white.opacity(bgPulse ? 0.22 : 0.06),
                    Color.clear
                ],
                center: .center,
                startRadius: 10,
                endRadius: bgPulse ? 420 : 200
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: bgPulse)
 
            // Soft top gradient for depth
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.60, blue: 0.75).opacity(0.55),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()
        }
    }
 
    // MARK: - Particle Layer
    private var particleLayer: some View {
        ForEach(0..<16, id: \.self) { i in
            Circle()
                .fill(Color.white.opacity(Double.random(in: 0.15...0.45)))
                .frame(
                    width: CGFloat.random(in: 4...12),
                    height: CGFloat.random(in: 4...12)
                )
                .offset(
                    x: CGFloat(i) * 24 - 180,
                    y: particleOffset + CGFloat(i % 3) * 80 - 120
                )
                .animation(
                    .easeInOut(duration: Double.random(in: 2.5...4.5))
                    .repeatForever(autoreverses: true)
                    .delay(Double(i) * 0.2),
                    value: particleOffset
                )
        }
    }
 
    // MARK: - Phase 1: Baby
    private var babyLayer: some View {
        ZStack {
            // Soft glow ring under baby
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.white.opacity(0.30), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 110
                    )
                )
                .frame(width: 220, height: 220)
                .blur(radius: 18)
 
            // ── Lottie Baby ──
            LottieView(filename: "baby")
                .frame(width: 240, height: 240)
        }
        .scaleEffect(babyScale)
        .opacity(babyOpacity)
        .animation(.spring(response: 0.8, dampingFraction: 0.6), value: babyScale)
        .animation(.easeIn(duration: 0.6), value: babyOpacity)
    }
 
    // MARK: - Phase 2: Twister around baby
    private var twistedLayer: some View {
        ZStack {
            // Inner baby (still visible, shrinking)
            LottieView(filename: "baby")
                .frame(width: 140, height: 140)
                .scaleEffect(twistedScale * 0.6)
                .opacity(twistedOpacity * 0.5)
 
            // ── Lottie Twister (wraps around) ──
            LottieView(filename: "Twister")
 
            // Energy glow during twister
            Circle()
                .strokeBorder(
                    LinearGradient(
                        colors: [Color.white, Color.pink.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
                .frame(width: 200 + glowRadius, height: 200 + glowRadius)
                .opacity(twistedOpacity * 0.6)
                .blur(radius: 4)
                .animation(
                    .easeInOut(duration: 0.9).repeatForever(autoreverses: true),
                    value: glowRadius
                )
        }
        .animation(.spring(response: 0.7, dampingFraction: 0.55), value: twistedScale)
        .animation(.easeIn(duration: 0.5), value: twistedOpacity)
    }
 
    // MARK: - Phase 3: Grown Man + "100"
    private var manLayer: some View {
        ZStack {
            // ── Bold "100" behind the man ──
            VStack{
                Text("100")
                    .font(.system(size: 160, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.95),
                                Color.white.opacity(0.60)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: Color(red: 0.9, green: 0.1, blue: 0.4).opacity(0.8), radius: 24, x: 0, y: 8)
                    .shadow(color: Color.white.opacity(0.4), radius: 6, x: 0, y: -2)
                    .scaleEffect(ageTextScale)
                    .opacity(ageTextOpacity)
                    .animation(.spring(response: 0.9, dampingFraction: 0.5), value: ageTextScale)
                    .animation(.easeIn(duration: 0.5), value: ageTextOpacity)
                Spacer()
            }
 
            // ── Vaibhav image (overlays on top of "100") ──
            Image("vaibhav")
                .resizable()
                .scaledToFill()
                .shadow(color: Color.black.opacity(0.35), radius: 20, x: 0, y: 12)
                .scaleEffect(manScale)
                .opacity(manOpacity)
                .animation(.spring(response: 0.85, dampingFraction: 0.55), value: manScale)
                .animation(.easeIn(duration: 0.55), value: manOpacity)
        }
        // Caption
        .overlay(alignment: .bottom) {
            if manOpacity > 0.8 {
                Text("A Legend is Born")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .tracking(3)
                    .foregroundColor(.white.opacity(0.85))
                    .padding(.top, 360)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
    }
 
    // MARK: - Story Animation Sequence
    private func startStory() {
        // Kick off particle drift
        particleOffset = -30
 
        // ── Act 1: Baby appears (0s) ──
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showBaby = true
            withAnimation {
                babyOpacity = 1
                babyScale = 1.0
            }
        }
 
        // ── Act 2: Twister wraps around baby (2.5s) ──
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeOut(duration: 0.4)) {
                babyOpacity = 0
                babyScale = 0.5
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                showBaby = false
                showTwister = true
                bgPulse = true
                glowRadius = 60
                withAnimation {
                    twistedOpacity = 1
                    twistedScale = 1.0
                }
            }
        }
 
        // ── Act 3: Man revealed (5.5s) ──
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            withAnimation(.easeOut(duration: 0.5)) {
                twistedOpacity = 0
                twistedScale = 1.4
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                showTwister = false
                bgPulse = false
                showMan = true
 
                // "100" crashes in first
                withAnimation(.spring(response: 0.7, dampingFraction: 0.45)) {
                    ageTextOpacity = 1
                    ageTextScale = 1.0
                }
 
                // Man appears 0.25s later on top
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    withAnimation(.spring(response: 0.75, dampingFraction: 0.5)) {
                        manOpacity = 1
                        manScale = 1.0
                    }
                }
            }
        }
    }
}
 
// MARK: - Preview
#Preview {
    VaibhavView()
}
