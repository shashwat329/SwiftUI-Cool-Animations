//
//  GrowthData.swift
//  CoolAnimationInSwiftUI
//
//  Created by Kumar Shashwat on 16/05/26.
//


//
import SwiftUI
import Charts

struct GrowthData: Identifiable, Codable {
    let id: UUID
    let date: Date
    let weight: Double?
    let height: Double?
    let bmi: Double?
    
    init(id: UUID = UUID(), date: Date, weight: Double?, height: Double?, bmi: Double?) {
        self.id = id
        self.date = date
        self.weight = weight
        self.height = height
        self.bmi = bmi
    }
    
    var ageInMonths: Int {
        let components = Calendar.current.dateComponents([.month], from: birthDate, to: date)
        return components.month ?? 0
    }
}
let birthDate = Calendar.current.date(byAdding: .month, value: -28, to: Date()) ?? Date()

// MARK: - Enums

enum Metric: String, CaseIterable {
    case weight = "Weight"
    case height = "Height"
    case bmi = "BMI"
    
    var unit: String {
        switch self {
        case .weight: return "kg"
        case .height: return "cm"
        case .bmi: return "BMI"
        }
    }
    
    var color: Color {
        switch self {
        case .weight: return .blue
        case .height: return .green
        case .bmi: return .orange
        }
    }
}

enum TimeRange: String, CaseIterable {
    case threeMonths = "3M"
    case sixMonths = "6M"
    case oneYear = "1Y"
    case allTime = "All"
    
    var months: Int? {
        switch self {
        case .threeMonths: return 3
        case .sixMonths: return 6
        case .oneYear: return 12
        case .allTime: return nil
        }
    }
}
