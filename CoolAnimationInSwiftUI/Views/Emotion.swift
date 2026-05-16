////
////  Emotion.swift
////  CoolAnimationInSwiftUI
////
////  Created by Kumar Shashwat on 12/05/26.
////
//
//
import SwiftUI

// MARK: - Emotion Model

enum Emotion: String, CaseIterable {
    case happy     = "Happy"
    case angry     = "Angry"
    case shy       = "Shy"
    case loved     = "Loved"
    case sad       = "Sad"
    case surprised = "Surprised"
    case sleepy    = "Sleepy"
    case cool      = "Cool"


    var config: EmotionConfig {
        switch self {
        case .happy:
            return EmotionConfig(
                eyeColor: .cyan,
                eyeScale: CGSize(width: 1.0, height: 1.0),
                eyeCornerRadius: 8,
                pupilOffset: .zero,
                pupilScale: CGSize(width: 1.0, height: 1.0),
                leftBrowAngle: 0,
                rightBrowAngle: 0,
                browYOffset: -10,
                blushOpacity: 0,
                showHearts: false,
                showSunglasses: false,
                animation: .blink
            )
        case .angry:
            return EmotionConfig(
                eyeColor: .cyan,
                eyeScale: CGSize(width: 1.0, height: 1.0),
                eyeCornerRadius: 4,
                pupilOffset: CGSize(width: -8, height: 5),
                pupilScale: CGSize(width: 0.9, height: 0.9),
                leftBrowAngle: 15,
                rightBrowAngle: -15,
                browYOffset: -6,
                blushOpacity: 0,
                showHearts: false,
                showSunglasses: false,
                animation: .shake
            )
        case .shy:
            return EmotionConfig(
                eyeColor: .cyan,
                eyeScale: CGSize(width: 1.0, height: 0.6),
                eyeCornerRadius: 8,
                pupilOffset: CGSize(width: 6, height: 0),
                pupilScale: CGSize(width: 0.8, height: 0.8),
                leftBrowAngle: -8,
                rightBrowAngle: 8,
                browYOffset: -4,
                blushOpacity: 0.7,
                showHearts: false,
                showSunglasses: false,
                animation: .wobble
            )
        case .loved:
            return EmotionConfig(
                eyeColor: .cyan,
                eyeScale: CGSize(width: 1.0, height: 1.0),
                eyeCornerRadius: 8,
                pupilOffset: .zero,
                pupilScale: CGSize(width: 0, height: 0),
                leftBrowAngle: 0,
                rightBrowAngle: 0,
                browYOffset: -10,
                blushOpacity: 0.75,
                showHearts: true,
                showSunglasses: false,
                animation: .pulse
            )
        case .sad:
            return EmotionConfig(
                eyeColor: .cyan,
                eyeScale: CGSize(width: 1.0, height: 1.0),
                eyeCornerRadius: 8,
                pupilOffset: CGSize(width: 0, height: 8),
                pupilScale: CGSize(width: 1.0, height: 1.0),
                leftBrowAngle: -10,
                rightBrowAngle: 10,
                browYOffset: -4,
                blushOpacity: 0,
                showHearts: false,
                showSunglasses: false,
                animation: .none
            )
        case .surprised:
            return EmotionConfig(
                eyeColor: .cyan,
                eyeScale: CGSize(width: 1.15, height: 1.15),
                eyeCornerRadius: 8,
                pupilOffset: .zero,
                pupilScale: CGSize(width: 1.3, height: 1.3),
                leftBrowAngle: 0,
                rightBrowAngle: 0,
                browYOffset: -18,
                blushOpacity: 0,
                showHearts: false,
                showSunglasses: false,
                animation: .none
            )
        case .sleepy:
            return EmotionConfig(
                eyeColor: .cyan,
                eyeScale: CGSize(width: 1.0, height: 0.45),
                eyeCornerRadius: 8,
                pupilOffset: .zero,
                pupilScale: CGSize(width: 1.0, height: 0.6),
                leftBrowAngle: 0,
                rightBrowAngle: 0,
                browYOffset: -4,
                blushOpacity: 0.25,
                showHearts: false,
                showSunglasses: false,
                animation: .none
            )
        case .cool:
            return EmotionConfig(
                eyeColor: .cyan,
                eyeScale: CGSize(width: 1.0, height: 1.0),
                eyeCornerRadius: 8,
                pupilOffset: .zero,
                pupilScale: CGSize(width: 2.0, height: 0.65),
                leftBrowAngle: -5,
                rightBrowAngle: 5,
                browYOffset: -8,
                blushOpacity: 0,
                showHearts: false,
                showSunglasses: true,
                animation: .none
            )
        }
    }
}

// MARK: - Config

struct EmotionConfig {
    var eyeColor: Color
    var eyeScale: CGSize
    var eyeCornerRadius: CGFloat
    var pupilOffset: CGSize
    var pupilScale: CGSize
    var leftBrowAngle: Double
    var rightBrowAngle: Double
    var browYOffset: CGFloat
    var blushOpacity: Double
    var showHearts: Bool
    var showSunglasses: Bool
    var animation: EyeAnimation
}

enum EyeAnimation {
    case none, blink, shake, wobble, pulse
}

// MARK: - Single Eye View

struct SquareEye: View {
    let config: EmotionConfig
    let isLeft: Bool

    @State private var blinkScale: CGFloat = 1.0
    @State private var shakeOffset: CGFloat = 0
    @State private var wobbleAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0

    private let eyeSize: CGFloat = 64

    var body: some View {
        ZStack {
            // Eye body
            RoundedRectangle(cornerRadius: config.eyeCornerRadius)
                .fill(config.eyeColor)
                .frame(width: eyeSize, height: eyeSize)
                .scaleEffect(x: config.eyeScale.width,
                             y: config.eyeScale.height * blinkScale)


            // Heart overlay (loved)
            if config.showHearts {
                Text("❤️")
                    .font(.system(size: 28))
            }

            // Sunglasses bar (cool)
            if config.showSunglasses {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white.opacity(0.18))
                    .frame(width: eyeSize - 10, height: 18)
            }
        }
        .offset(x: shakeOffset)
        .rotationEffect(.degrees(wobbleAngle))
        .scaleEffect(pulseScale)
        .onAppear { startAnimation() }
        .onChange(of: config.animation) { _ in
            resetAnimations()
            startAnimation()
        }
    }

    private func resetAnimations() {
        withAnimation(.easeOut(duration: 0.15)) {
            shakeOffset = 0
            wobbleAngle = 0
            pulseScale = 1.0
            blinkScale = 1.0
        }
    }

    private func startAnimation() {
        switch config.animation {
        case .blink:
            scheduleBlink()
        case .shake:
            startShake()
        case .wobble:
            startWobble()
        case .pulse:
            startPulse()
        case .none:
            break
        }
    }

    private func scheduleBlink() {
        let delay = Double.random(in: 3.5...6.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard config.animation == .blink else { return }

            // Close eye slowly
            withAnimation(.easeInOut(duration: 0.15)) {
                blinkScale = 0.08
            }

            // Open eye smoothly
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                withAnimation(.easeInOut(duration: 0.35)) {
                    blinkScale = 1.0
                }

                scheduleBlink()
            }
        }
    }

    private func startShake() {
        guard config.animation == .shake else { return }
        withAnimation(.easeInOut(duration: 0.08)) { shakeOffset = -6 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            withAnimation(.easeInOut(duration: 0.08)) { shakeOffset = 6 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                withAnimation(.easeInOut(duration: 0.08)) { shakeOffset = -4 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                    withAnimation(.easeInOut(duration: 0.28)) { shakeOffset = 0 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        startShake()
                    }
                }
            }
        }
    }

    private func startWobble() {
        guard config.animation == .wobble else { return }
        withAnimation(.easeInOut(duration: 0.5)) { wobbleAngle = isLeft ? -4 : 4 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 2.5)) { wobbleAngle = isLeft ? 4 : -4 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { startWobble() }
        }
    }

    private func startPulse() {
        guard config.animation == .pulse else { return }
        withAnimation(.easeInOut(duration: 2.5)) { pulseScale = 1.1 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 2.5)) { pulseScale = 1.0 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { startPulse() }
        }
    }
}

// MARK: - Face View

struct SquareFaceView: View {
    let config: EmotionConfig

    var body: some View {
        VStack(spacing: 0) {
            // Eyebrows + Eyes
            HStack(spacing: 28) {
                eyeWithBrow(isLeft: true)
                eyeWithBrow(isLeft: false)
            }
        }
    }

    @ViewBuilder
    private func eyeWithBrow(isLeft: Bool) -> some View {
        let angle = isLeft ? config.leftBrowAngle : config.rightBrowAngle

        VStack(spacing: 6) {
            // Eyebrow
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.cyan)
                .frame(width: 56, height: 5)
                .rotationEffect(.degrees(angle))
                .offset(y: config.browYOffset)

            // Eye
            ZStack {
                SquareEye(config: config, isLeft: isLeft)

                // Blush cheeks (outside the eye, positioned via overlay on sides)
            }
        }
    }
}

// MARK: - Main Content View

struct SquareEyesView: View {
    @State private var selectedEmotion: Emotion = .happy
    @State private var config: EmotionConfig = Emotion.happy.config
    @State private var faceShake: CGFloat = 0

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(spacing: 0) {

            Spacer()

            // Face
            ZStack {
                // Blush cheeks
                HStack(spacing: 172) {
                    Ellipse()
                        .fill(Color.pink.opacity(0.5))
                        .frame(width: 36, height: 20)
                    Ellipse()
                        .fill(Color.pink.opacity(0.5))
                        .frame(width: 36, height: 20)
                }
                .opacity(config.blushOpacity)
                .animation(.easeInOut(duration: 0.4), value: config.blushOpacity)

                SquareFaceView(config: config)
                    .offset(x: faceShake)
            }
            .frame(height: 180)

            Spacer()

            LazyVGrid(columns: columns, spacing: 14) {

                            ForEach(Emotion.allCases, id: \.self) { emotion in

                                Button {

                                    switchEmotion(to: emotion)

                                } label: {

                                    Text(emotion.rawValue)
                                        .font(
                                            .system(
                                                size: 13,
                                                weight: .semibold,
                                                design: .rounded
                                            )
                                        )
                                        .foregroundStyle(
                                            selectedEmotion == emotion
                                            ? .black
                                            : .white
                                        )
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(

                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(
                                                    selectedEmotion == emotion
                                                    ? .white
                                                    : .white.opacity(0.08)
                                                )
                                        )
                                        .overlay {

                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    .white.opacity(0.08),
                                                    lineWidth: 1
                                                )
                                        }
                                        .shadow(
                                            color: config.eyeColor.opacity(0.5),
                                            radius: 15
                                            )
                                        .scaleEffect(
                                            selectedEmotion == emotion
                                            ? 1.04
                                            : 1
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
        }
        .background(
            LinearGradient(
                         colors: [
                             Color.black,
                             Color.cyan.opacity(0.12)
                         ],
                         startPoint: .top,
                         endPoint: .bottom
                     )
                     .ignoresSafeArea()
        )
    }

    private func switchEmotion(to emotion: Emotion) {
        guard emotion != selectedEmotion else { return }
        withAnimation(.spring(response: 0.45, dampingFraction: 0.65)) {
            selectedEmotion = emotion
            config = emotion.config
        }
    }
}

// MARK: - Preview

#Preview {
    SquareEyesView()
}
