//
//  ContentView.swift
//  CoolAnimationInSwiftUI
//
//  Created by Kumar Shashwat on 24/04/26.
//

import SwiftUI

struct ContentView: View{
    let columns = [
           GridItem(.flexible()),
           GridItem(.flexible()),
           GridItem(.flexible())
       ]
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(array) { item in
                        NavigationLink {
                            item.destinationView
                        }label: {
                            VStack {
                                item.icon
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .padding(.bottom,4)
                                Text(item.name)
                                    .font(.caption)
                                    .foregroundStyle(Color.white)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(height: 100)
                            .frame(maxWidth: .infinity)
                            .background(item.backgroundColor)
                            .cornerRadius(12)
                            .shadow(radius: 2)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Animation in SwiftUI")
            .multilineTextAlignment(.center)
            .lineLimit(2)
        }
    }
}

#Preview {
    ContentView()
}
