import SwiftUI

// MARK: - Mood State
enum Mood {
    case bad, notBad, good

    var label: String {
        switch self {
        case .bad:    return "BAD"
        case .notBad: return "NOT BAD"
        case .good:   return "GOOD"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .bad:    return Color(red: 0.95, green: 0.35, blue: 0.20)  // orange-red
        case .notBad: return Color(red: 0.95, green: 0.72, blue: 0.10)  // yellow
        case .good:   return Color(red: 0.55, green: 0.90, blue: 0.20)  // lime green
        }
    }

    var faceColor: Color {
        switch self {
        case .bad:    return Color(red: 0.75, green: 0.22, blue: 0.10)
        case .notBad: return Color(red: 0.75, green: 0.52, blue: 0.05)
        case .good:   return Color(red: 0.28, green: 0.68, blue: 0.08)
        }
    }
}

// MARK: - Face View
struct AnimatedFaceView: View {
    var sliderValue: Double   // 0 = bad, 0.5 = not bad, 1 = good

    // Eye size: scales from small (bad/squinted) to large (good/open)
    private var eyeSize: CGFloat {
        let base: CGFloat = 28
        let range: CGFloat = 36
        return base + CGFloat(sliderValue) * range
    }

    // Eye vertical offset: drooping when bad
    private var eyeDropOffset: CGFloat {
        return CGFloat((1 - sliderValue)) * 8
    }

    // Eye shape: squished when bad
    private var eyeAspect: CGFloat {
        // 0.5 (squint) → 1.0 (circle)
        return 0.5 + CGFloat(sliderValue) * 0.5
    }

    // Mouth: frown (-1) → flat (0) → smile (1)
    private var mouthCurve: Double {
        return sliderValue * 2 - 1  // -1 to 1
    }

    private var mood: Mood {
        if sliderValue < 0.33 { return .bad }
        else if sliderValue < 0.66 { return .notBad }
        else { return .good }
    }

    var body: some View {
        VStack(spacing: 18) {
            // Eyes
            HStack(spacing: 28) {
                ForEach(0..<2, id: \.self) { _ in
                    Ellipse()
                        .fill(mood.faceColor)
                        .frame(width: eyeSize, height: eyeSize * eyeAspect)
                        .offset(y: eyeDropOffset)
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: sliderValue)

            // Mouth
            MouthShape(curve: mouthCurve)
                .stroke(mood.faceColor, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .frame(width: 80, height: 40)
                .animation(.spring(response: 0.35, dampingFraction: 0.7), value: sliderValue)
        }
    }
}

// MARK: - Mouth Shape
struct MouthShape: Shape {
    var curve: Double   // -1 = frown, 0 = flat, 1 = smile

    var animatableData: Double { get { curve } set { curve = newValue } }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midX = rect.midX
        let midY = rect.midY
        let width = rect.width
        let controlOffset = CGFloat(curve) * rect.height * 0.8

        path.move(to: CGPoint(x: midX - width / 2, y: midY))
        path.addQuadCurve(
            to: CGPoint(x: midX + width / 2, y: midY),
            control: CGPoint(x: midX, y: midY + controlOffset)
        )
        return path
    }
}

// MARK: - Main View
struct ShoppingFeedbackView: View {
    @State private var sliderValue: Double = 0.0
    @State private var note: String = ""
    @State private var submitted = false

    private var mood: Mood {
        if sliderValue < 0.33 { return .bad }
        else if sliderValue < 0.66 { return .notBad }
        else { return .good }
    }

    var body: some View {
        ZStack {
            mood.backgroundColor
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.4), value: mood.label)

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {}) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(mood.faceColor)
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                Spacer()

                // Question
                Text("How was your shopping\nexperience?")
                    .font(.system(size: 22, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)

                Spacer().frame(height: 32)

                // Animated Face
                AnimatedFaceView(sliderValue: sliderValue)
                    .frame(height: 120)

                Spacer().frame(height: 24)

                // Mood Label
                Text(mood.label)
                    .font(.system(size: 42, weight: .heavy))
                    .foregroundColor(mood.faceColor.opacity(0.55))
                    .animation(.easeInOut(duration: 0.2), value: mood.label)

                Spacer().frame(height: 32)

                // Slider
                VStack(spacing: 8) {
                    ZStack(alignment: .leading) {
                        // Track background
                        Capsule()
                            .fill(mood.faceColor.opacity(0.25))
                            .frame(height: 4)

                        // Track fill
                        Capsule()
                            .fill(mood.faceColor)
                            .frame(width: CGFloat(sliderValue) * (UIScreen.main.bounds.width - 64), height: 4)

                        // Thumb
                        Circle()
                            .fill(mood.faceColor)
                            .frame(width: 32, height: 32)
                            .offset(x: max(0, CGFloat(sliderValue) * (UIScreen.main.bounds.width - 64) - 16))
                    }
                    .frame(height: 32)
                    .padding(.horizontal, 32)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let width = UIScreen.main.bounds.width - 64
                                let newVal = Double(value.location.x / width)
                                sliderValue = min(max(newVal, 0), 1)
                            }
                    )

                    HStack {
                        Text("Bad")
                        Spacer()
                        Text("Not Bad")
                        Spacer()
                        Text("Good")
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(mood.faceColor.opacity(0.7))
                    .padding(.horizontal, 32)
                }

                Spacer().frame(height: 24)

                // Add note + Submit
                HStack(spacing: 12) {
                    TextField("Add note", text: $note)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(14)
                        .font(.system(size: 15))

                    Button(action: { submitted = true }) {
                        HStack(spacing: 6) {
                            Text("Submit")
                                .font(.system(size: 15, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(mood.faceColor)
                        .cornerRadius(14)
                    }
                }
                .padding(.horizontal, 24)

                Spacer().frame(height: 40)
            }
        }
        .alert("Thanks for your feedback!", isPresented: $submitted) {
            Button("OK", role: .cancel) {}
        }
    }
}

// MARK: - Preview
#Preview {
    ShoppingFeedbackView()
}