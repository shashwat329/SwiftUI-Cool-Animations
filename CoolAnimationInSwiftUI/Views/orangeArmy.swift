//
//  orangeArmy.swift
//  CoolAnimationInSwiftUI
//
//  Created by Kumar Shashwat on 25/04/26.
//

import SwiftUI

struct OrangeArmy: View {
    var body: some View {
        BurstSplashView()
    }
}

struct BurstSplashView: View {
    
    @State private var burst = false
    @State private var showContent = false
    @State private var showImage = false
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            Circle()
                .fill(Color.orangeArmyTheme)
                .scaleEffect(burst ? 20 : 0.01) // explosion effect
                .animation(.easeOut(duration: 3.5), value: burst)
            if showContent {
                VStack{
                    Image("abhi")
                }
            }
            if showImage{
                VStack{
                    Image("helmet")
                        .padding(.top,90)
                    Text("This is for Orange Army")
                        .foregroundStyle(Color.white)
                        .font(.largeTitle)
                        .fontDesign(.serif)
                    Spacer()
                }
            }
        }
        .onAppear {
            burst = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showContent = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showContent = false
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.spring() ){
                    showImage = true
                }
            }
        }
    }
}

#Preview {
    OrangeArmy()
}
