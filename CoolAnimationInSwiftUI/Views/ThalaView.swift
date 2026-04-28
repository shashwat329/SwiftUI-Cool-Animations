import SwiftUI

struct DhoniAnimationView: View {
    
    @State private var showLogo = false
    @State private var showPlayer = false
    @State private var logoScale: CGFloat = 0.3
    @State private var logoRotation: Double = -15
    @State private var ballOpacity: Double = 0
    @State private var overlayOpacity: Double = 0
    @State private var showBoundary = false
    @State private var boundaryScale: CGFloat = 0.1
    @State private var shimmerOffset: CGFloat = -300
    @State private var playerGlow: Double = 0
    @State private var playerOpacity: Double = 1
    @State private var showWhistleText = false
    @State private var whistleLetterOpacities: [Double] = Array(repeating: 0, count: 13)
    
    let whistleText = Array("WHISTLE PODU!")
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#F5C518"), Color(hex: "#E8A500")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // ✅ VStack keeps logo and text vertically stacked and centered
            VStack(spacing: 0) {
                
                // Radial glow + CSK Logo block
                ZStack {
                    if showLogo {
                        RadialGradient(
                            colors: [Color.white.opacity(0.35), Color.clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 160
                        )
                        .frame(width: 320, height: 320)
                        .animation(.easeOut(duration: 1.4), value: showLogo)
                    }
                    
                    // CSK Logo with shimmer
                    ZStack {
                        Image("csk_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 220)
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0),
                                        Color.white.opacity(0.45),
                                        Color.white.opacity(0)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 80, height: 220)
                            .offset(x: shimmerOffset)
                            .clipped()
                            .allowsHitTesting(false)
                    }
                    .frame(width: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .scaleEffect(logoScale)
                    .rotationEffect(.degrees(logoRotation))
                    .opacity(showLogo ? 1 : 0)
                }
                .frame(height: 260)
                
                // ✅ WHISTLE PODU sits directly below the logo
                if showWhistleText {
                    VStack(spacing: 0) {
                        // Letter-by-letter main text
                        HStack(spacing: 2) {
                            ForEach(Array(whistleText.enumerated()), id: \.offset) { index, char in
                                Text(String(char))
                                    .font(.system(
                                        size: char == " " ? 18 : 44,
                                        weight: .black,
                                        design: .rounded
                                    ))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color.white, Color(hex: "#FFE066")],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .shadow(
                                        color: Color(hex: "#C47F00").opacity(0.8),
                                        radius: 0, x: 3, y: 3
                                    )
                                    .shadow(
                                        color: Color.black.opacity(0.3),
                                        radius: 6, x: 0, y: 4
                                    )
                                    .scaleEffect(
                                        (whistleLetterOpacities[safe: index] ?? 0) > 0.5 ? 1.0 : 0.4
                                    )
                                    .opacity(whistleLetterOpacities[safe: index] ?? 0)
                                    .animation(
                                        .spring(response: 0.4, dampingFraction: 0.55)
                                        .delay(Double(index) * 0.06),
                                        value: whistleLetterOpacities[safe: index] ?? 0
                                    )
                            }
                        }
                        
                        // Underline accent bar
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white.opacity(0.9))
                            .frame(width: showWhistleText ? 280 : 0, height: 4)
                            .animation(
                                .easeOut(duration: 0.6).delay(0.8),
                                value: showWhistleText
                            )
                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                            .padding(.top, 6)
                        
                        // Subtitle
                        Text("Chennai Super Kings 🦁")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.white.opacity(0.9))
                            .opacity(showWhistleText ? 1 : 0)
                            .offset(y: showWhistleText ? 0 : 20)
                            .animation(
                                .easeOut(duration: 0.5).delay(1.0),
                                value: showWhistleText
                            )
                            .padding(.top, 10)
                    }
                    .padding(.top, 12)     // ✅ small gap between logo and text
                }
            }
            
            // Dhoni — stays in ZStack so he overlaps the background freely
            Image("dhoni_cartoon")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                .offset(x: showPlayer ? 0 : 400)
                .opacity(playerOpacity)
                .shadow(
                    color: Color.yellow.opacity(playerGlow),
                    radius: 24, x: 0, y: 8
                )
                .animation(
                    .spring(response: 0.65, dampingFraction: 0.72, blendDuration: 0),
                    value: showPlayer
                )
                .animation(.easeOut(duration: 0.5), value: playerOpacity)
            
            // Dark overlay
            Color.black
                .opacity(overlayOpacity)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: overlayOpacity)
            
            // Cricket Ball Lottie
            LottieView(filename: "CricketBall")
                .opacity(ballOpacity)
                .animation(.easeIn(duration: 0.3), value: ballOpacity)
                .allowsHitTesting(ballOpacity > 0)
            
            // SIX Boundary Lottie
            LottieView(filename: "SIXANIMATION")
                .scaleEffect(boundaryScale)
                .opacity(showBoundary ? 1 : 0)
                .animation(
                    .spring(response: 0.5, dampingFraction: 0.55),
                    value: boundaryScale
                )
                .animation(.easeIn(duration: 0.2), value: showBoundary)
                .allowsHitTesting(showBoundary)
        }
        .onAppear {
            startAnimation()
        }
    }
    
    func startAnimation() {
        // Step 1: Logo springs in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6)) {
                showLogo = true
                logoScale = 1.0
                logoRotation = 0
            }
        }
        
        // Step 1b: Shimmer sweep
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeInOut(duration: 0.7)) {
                shimmerOffset = 300
            }
        }
        
        // Step 2: Dhoni slides in
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            showPlayer = true
            withAnimation(.easeIn(duration: 0.4)) { playerGlow = 0.6 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation(.easeOut(duration: 0.4)) { playerGlow = 0 }
        }
        
        // Step 3: Dark overlay fades in
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.5)) { overlayOpacity = 0.85 }
        }
        
        // Step 3b: Ball appears
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            ballOpacity = 1.0
        }
        
        // Step 4: SIX boundary
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.9) {
            showBoundary = true
            withAnimation(.spring(response: 0.5, dampingFraction: 0.55)) {
                boundaryScale = 1.0
            }
        }
        
        // Step 5: Dhoni fades out after SIX lands
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.8) {
            withAnimation(.easeOut(duration: 0.5)) {
                playerOpacity = 0
                ballOpacity = 0
                showBoundary = false
                boundaryScale = 0.1
                overlayOpacity = 0
            }
        }
        
        // Step 6: WHISTLE PODU letter by letter
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.4) {
            showWhistleText = true
            for i in 0..<whistleLetterOpacities.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.06) {
                    whistleLetterOpacities[i] = 1.0
                }
            }
        }
    }
}

// MARK: - Safe array subscript
extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Hex color helper
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    DhoniAnimationView()
}
