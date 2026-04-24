//
//  ViewCatalog.swift
//  CoolAnimationInSwiftUI
//
//  Created by Kumar Shashwat on 24/04/26.
//

import Foundation
import SwiftUI

struct ViewCatalog: Identifiable {
    let id = UUID()
    let name: String
    let icon: Image
    let backgroundColor: Color
    let destinationView: AnyView
}

// array of ViewCatalog
let feedback =  ViewCatalog(
    name: "Feedback",
    icon: Image(systemName: "hand.thumbsup.fill"),
    backgroundColor: Color(.blue).opacity(0.5),
    destinationView: AnyView(ShoppingFeedbackView())
)
let array: [ViewCatalog] = [
    feedback
]
