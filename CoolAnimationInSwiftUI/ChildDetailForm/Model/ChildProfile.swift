//
//  ChildProfile.swift
//  NutriSphere
//
//  Created by shashwat singh on 14/02/26.
//

import Foundation

struct ChildProfile: Codable {
    let selectedAvatar: String
    let name: String
    let ageGroup: AgeGroup
    let gender: String
    let weight: Double
    let height: Double
}
