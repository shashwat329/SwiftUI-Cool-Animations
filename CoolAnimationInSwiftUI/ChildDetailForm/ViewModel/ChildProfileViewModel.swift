//
//  ChildProfileViewModel.swift
//  NutriSphere
//
//  Created by shashwat singh on 14/02/26.
//


import SwiftUI
import Combine

final class ChildProfileViewModel: ObservableObject {
    @AppStorage("completedSignup") var completedSignup = false
    enum Gender: String, CaseIterable, Codable {
        case boy = "Boy"
        case girl = "Girl"
        case other = "Other"
    }
    
    // MARK: - Published Properties
    @Published var selectedAvatarName = ""
    @Published var selectedAvatar: Int = 0
    @Published var name: String = ""
    @Published var selectedAgeGroup: AgeGroup? = .zeroToSixMonths
    @Published var ageGroupError: String?
    @Published var gender: Gender = .boy
    @Published var weight: String = ""
    @Published var height: String = ""
    
    @Published var nameError: String?
    @Published var weightError: String?
    @Published var heightError: String?
//    @Published var birthDateError: String?
    
    private let userDefaultsKey = "child_profile"
    
    // MARK: - Init
    init() {
        loadProfile()
    }
    
    // MARK: - Validation
    var isFormValid: Bool {
        !name.isEmpty &&
        Double(weight) != nil &&
        Double(height) != nil
    }
    var childProfile: ChildProfile {
        ChildProfile(
            selectedAvatar: selectedAvatarName,
            name: name,
            ageGroup: selectedAgeGroup ?? .zeroToSixMonths,
            gender: gender.rawValue,
            weight: Double(weight) ?? 0,
            height: Double(height) ?? 0
        )
    }
    
    func validate() -> Bool {
        nameError = name.isEmpty ? "Name is required" : nil
        weightError = Double(weight) == nil ? "Enter valid weight" : nil
        heightError = Double(height) == nil ? "Enter valid height" : nil
         if selectedAgeGroup == nil {
        ageGroupError = "Please select age group"
    } else {
        ageGroupError = nil
    }
        
        return isFormValid
    }
    func convertSelectedIDtoSelectedAvatar(id: Int) -> String{
        if id == 0 {
           return "whitegirl"
        }
        else if id == 1 {
            return "blackgirl"
        }
        else if id == 2{
            return "whiteKid"
        }
        return "blackboy"
    }
    
    // MARK: - Save
    func saveProfile() {
        guard validate(),
              let weightDouble = Double(weight),
              let heightDouble = Double(height) else { return }
        guard let ageGroup = selectedAgeGroup else {
            ageGroupError = "Please select age group"
            return
        }
        selectedAvatarName = convertSelectedIDtoSelectedAvatar(id: selectedAvatar)
        let profile = ChildProfile(
            selectedAvatar: selectedAvatarName,
            name: name,
            ageGroup: ageGroup,
            gender: gender.rawValue,
            weight: weightDouble,
            height: heightDouble
        )
        
        do {
            let data = try JSONEncoder().encode(profile)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Failed to save profile:", error)
        }
    }
    
    // MARK: - Load
    func loadProfile() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
        
        do {
            let profile = try JSONDecoder().decode(ChildProfile.self, from: data)
            
            selectedAvatarName = profile.selectedAvatar
            name = profile.name
            selectedAgeGroup = profile.ageGroup
            gender = Gender(rawValue: profile.gender) ?? .boy
            weight = String(profile.weight)
            height = String(profile.height)
            
        } catch {
            print("Failed to load profile:", error)
        }
    }
    
    func updateProfile(with entry: GrowthData) {
        // Update only if values exist
        if let newWeight = entry.weight {
            weight = String(newWeight)
        }
        
        if let newHeight = entry.height {
            height = String(newHeight)
        }
        
        // Save updated profile to UserDefaults
        saveProfile()
    }
    func logout() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        
        // Reset all properties to default values
        selectedAvatarName = ""
        selectedAvatar = 0
        name = ""
        selectedAgeGroup = .zeroToSixMonths
        gender = .boy
        weight = ""
        height = ""
        
        // Clear errors
        nameError = nil
        weightError = nil
        heightError = nil
        ageGroupError = nil
        
        completedSignup = false
    }
}

