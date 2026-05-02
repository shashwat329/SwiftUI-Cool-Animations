//
//  Mood.swift
//  CoolAnimationInSwiftUI
//
//  Created by Kumar Shashwat on 24/04/26.
//


import SwiftUI

struct AnimatedFaceView: View {
    var value: Double
    private var eyeWidth: CGFloat  { lerp(22, 58, value) }
    private var eyeHeight: CGFloat { lerp(22, 58, value) }
    private var eyeDropY: CGFloat  { lerp(10,  0, value) }
    private var eyeSpacing: CGFloat { lerp(20, 32, value) }

    private var pupilOpacity: Double { smoothstep(0.45, 1.0, value) }

    
    private var mouthCurve: Double { value * 2 - 1 }
    private var mouthWidth: CGFloat { lerp(50, 88, value) }

    private var faceColor: Color {
        interpolateColor(
            from: Color(red: 0.70, green: 0.16, blue: 0.06),
            mid:  Color(red: 0.66, green: 0.46, blue: 0.03),
            to:   Color(red: 0.20, green: 0.58, blue: 0.05),
            t: value
        )
    }

    var body: some View {
        VStack(spacing: 22) {
            // Eyes
            HStack(spacing: eyeSpacing) {
                ForEach(0..<2, id: \.self) { _ in
                    ZStack {
                        Ellipse()
                            .fill(faceColor)
                            .frame(width: eyeWidth, height: eyeHeight)
                        
                        Circle()
                            .fill(Color.white.opacity(0.38))
                            .frame(width: eyeWidth * 0.28, height: eyeWidth * 0.28)
                            .offset(x: eyeWidth * 0.17, y: -eyeHeight * 0.17)
                            .opacity(pupilOpacity)
                            .scaleEffect(pupilOpacity)
                    }
                    .offset(y: eyeDropY)
                }
            }

            // Mouth
            MouthShape(curve: mouthCurve)
                .stroke(faceColor,
                        style: StrokeStyle(lineWidth: 5.5, lineCap: .round))
                .frame(width: mouthWidth, height: 44)
        }
    }
}

// MARK: - Mouth (animatable bezier curve)
struct MouthShape: Shape {
    var curve: Double
    var animatableData: Double {
        get { curve }
        set { curve = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midX = rect.midX
        let midY = rect.midY
        let halfW = rect.width / 2
        let controlY = midY + CGFloat(curve) * rect.height * 0.85

        path.move(to: CGPoint(x: midX - halfW, y: midY))
        path.addQuadCurve(
            to: CGPoint(x: midX + halfW, y: midY),
            control: CGPoint(x: midX, y: controlY)
        )
        return path
    }
}

// MARK: - Custom Slider
struct MoodSlider: View {
    @Binding var value: Double
    @State private var isDragging = false

    private var thumbColor: Color {
        interpolateColor(
            from: Color(red: 0.70, green: 0.16, blue: 0.06),
            mid:  Color(red: 0.66, green: 0.46, blue: 0.03),
            to:   Color(red: 0.20, green: 0.58, blue: 0.05),
            t: value
        )
    }

    var body: some View {
        GeometryReader { geo in
            let trackW = geo.size.width
            let thumbX  = CGFloat(value) * trackW
            let thumbR: CGFloat = isDragging ? 18 : 14
            let dotR: CGFloat   = isDragging ? 10 :  7

            ZStack(alignment: .leading) {
                // Track background
                Capsule()
                    .fill(Color.white.opacity(0.28))
                    .frame(height: 5)

                // Thumb
                ZStack {
                    Circle()
                        .fill(thumbColor)
                        .frame(width: thumbR * 2.5, height: thumbR * 2.5)
                        .shadow(color: thumbColor.opacity(0.55),
                                radius: isDragging ? 14 : 6, y: 3)

                    Image(systemName: "minus")
                        .foregroundStyle(Color.white)
                }
                .offset(x: thumbX - thumbR)
                .animation(.spring(response: 0.22, dampingFraction: 0.62), value: isDragging)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { drag in
                        isDragging = true
                        value = min(max(Double(drag.location.x / trackW), 0), 1)
                    }
                    .onEnded { _ in
                        isDragging = false
                        let zones: [Double] = [0.0, 0.5, 1.0]
                        let nearest = zones.min { abs($0 - value) < abs($1 - value) }!
                        withAnimation(.spring(response: 0.42, dampingFraction: 0.72)) {
                            value = nearest
                        }
                    }
            )
        }
        .frame(height: 36)
    }
}

// MARK: - Main View
struct ShoppingFeedbackView: View {
    @State private var sliderValue: Double = 0.49
    @State private var note: String = ""
    @State private var submitted = false

    private var bgColor: Color {
        interpolateColor(
            from: Color(red: 0.95, green: 0.33, blue: 0.18),
            mid:  Color(red: 0.98, green: 0.76, blue: 0.12),
            to:   Color(red: 0.60, green: 0.94, blue: 0.20),
            t: sliderValue
        )
    }

    private var accentColor: Color {
        interpolateColor(
            from: Color(red: 0.70, green: 0.16, blue: 0.06),
            mid:  Color(red: 0.66, green: 0.46, blue: 0.03),
            to:   Color(red: 0.20, green: 0.58, blue: 0.05),
            t: sliderValue
        )
    }

    private var moodLabel: String {
        if sliderValue < 0.33 { return "BAD" }
        else if sliderValue < 0.66 { return "NOT BAD" }
        else { return "GOOD" }
    }

    var body: some View {
        ZStack {
            // Background — smoothly follows slider
            bgColor
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.3), value: sliderValue)

            VStack(spacing: 0) {

                // ── Close ──
                HStack {
                    Button(action: {}) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white.opacity(0.85))
                            .padding(10)
                            .background(Color.black.opacity(0.22))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                Text("How was your shopping\nexperience?")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal, 32)

                Spacer()

                // ── Face ──
                AnimatedFaceView(value: sliderValue)
                    .frame(height: 130)
                    // Smooth continuous physics animation on every value change
                    .animation(
                        .spring(response: 0.30, dampingFraction: 0.68),
                        value: sliderValue
                    )

                Spacer().frame(height: 18)

                // ── Mood Label ──
                Text(moodLabel)
                    .font(.system(size: 46, weight: .black, design: .rounded))
                    .foregroundColor(accentColor.opacity(0.50))
                    .contentTransition(.numericText())
                    .animation(
                        .spring(response: 0.28, dampingFraction: 0.70),
                        value: moodLabel
                    )

                Spacer()
                // ── Slider ──
                VStack(spacing: 10) {
                    MoodSlider(value: $sliderValue)
                        .padding(.horizontal, 32)
//
                    HStack {
                        Text("Bad")
                            .font(.headline)
                            .foregroundColor(accentColor)
                        Spacer()
                        Text("Not Bad")
                            .font(.headline)
                            .foregroundStyle(accentColor)
                        Spacer()
                        Text("Good")
                            .font(.headline)
                            .foregroundColor(accentColor)
                    }
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.62))
                    .padding(.horizontal, 32)
                }

                Spacer().frame(height: 28)

                // ── Note + Submit ──
                HStack(spacing: 10) {
                    TextField("Add note", text: $note)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color.white.opacity(0.92))
                        .cornerRadius(16)
                        .font(.system(size: 15, design: .rounded))

                    Button(action: { submitted = true }) {
                        HStack(spacing: 6) {
                            Text("Submit")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 13, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(accentColor)
                        .cornerRadius(16)
                        .shadow(color: accentColor.opacity(0.5), radius: 10, y: 4)
                    }
                    .animation(.easeInOut(duration: 0.3), value: sliderValue)
                }
                .padding(.horizontal, 24)

                Spacer().frame(height: 44)
            }
        }
        .alert("Thanks for your feedback! 🎉", isPresented: $submitted) {
            Button("Done", role: .cancel) {}
        }
    }
}

func lerp(_ a: CGFloat, _ b: CGFloat, _ t: Double) -> CGFloat {
    a + (b - a) * CGFloat(t)
}

func smoothstep(_ edge0: Double, _ edge1: Double, _ x: Double) -> Double {
    let t = min(max((x - edge0) / (edge1 - edge0), 0), 1)
    return t * t * (3 - 2 * t)
}

// MARK: - Color Helpers

func interpolateColor(from: Color, mid: Color, to: Color, t: Double) -> Color {
    t <= 0.5
        ? lerpColor(from, mid, t * 2)
        : lerpColor(mid, to, (t - 0.5) * 2)
}

func lerpColor(_ a: Color, _ b: Color, _ t: Double) -> Color {
    let ai = UIColor(a).rgba
    let bi = UIColor(b).rgba
    return Color(
        red:   ai.r + (bi.r - ai.r) * t,
        green: ai.g + (bi.g - ai.g) * t,
        blue:  ai.b + (bi.b - ai.b) * t
    )
}

extension UIColor {
    var rgba: (r: Double, g: Double, b: Double, a: Double) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Double(r), Double(g), Double(b), Double(a))
    }
}

// MARK: - Preview
#Preview {
    ShoppingFeedbackView()
}
