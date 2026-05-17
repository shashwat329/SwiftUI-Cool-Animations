//
//  DSSectionTitle.swift
//  NutriSphere
//
//  Created by shashwat singh on 14/02/26.
//

import SwiftUI

struct DSSectionTitle: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 22, weight: .semibold))
            .frame(maxWidth: .infinity, alignment: .center)
    }
}
