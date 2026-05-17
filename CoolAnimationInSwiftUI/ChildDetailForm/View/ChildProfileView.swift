//
//  ChildProfileView.swift
//  NutriSphere
//
//  Created by shashwat singh on 14/02/26.
//
import SwiftUI

@available(iOS 26.0, *)
struct ChildProfileView: View {
    @AppStorage("completedSignup") var completedSignup = false
    @EnvironmentObject var vm :ChildProfileViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                DSSectionTitle(title: "Welcome to NutriSphere!")
                Text("Help us personalize your nutrition journey by telling us about your little one.")
                    .frame(maxWidth: .infinity,alignment: .center)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.gray.opacity(0.9))
                    .padding(.top,-16)
                    .padding(.bottom,10)
                
                DSAvatarPicker(selectedIndex: $vm.selectedAvatar)
                
                
                DSInputField(
                  title: "Child’s Name",
                  placeholder: "Enter child’s name",
                  text: $vm.name,
                  error: vm.nameError
                )
                DSAgeGroupInputField(
                  title: "Select Age Group",
                  selectedAgeGroup: $vm.selectedAgeGroup,
                  error: vm.ageGroupError
                )
                DSGenderSelector(selected:$vm.gender)
                    .onTapGesture {
                        hideKeyboard()
                    }
               
                HStack(spacing: 16) {
                 DSInputField(
                    title: "Current Weight",
                    placeholder: "",
                    text: $vm.weight,
                    error: vm.weightError,
                    keyboard: .decimalPad,
                    trailing: "KG"
                 )
                    DSInputField(
                       title: "Current Height",
                       placeholder: "",
                       text: $vm.height,
                       error: vm.heightError,
                       keyboard: .decimalPad,
                       trailing: "CM"
                    )
//                   
                }
                DSGradientButton(title: "Save", isEnabled: vm.isFormValid) {
                    vm.saveProfile()
                }
                footer
            }
            .onTapGesture {
                hideKeyboard()
            }
            .padding(.horizontal,24)
            .padding(.bottom,24)
        }
        .navigationDestination(isPresented: $completedSignup, destination: {
            EmptyView()
        })
        .navigationTitle("Child's Profile")
        .background(DSColors.background)
    }
    
    private var footer: some View {
        Text("This information helps us calculate precise nutritional needs based on WHO growth standards.")
            .font(.system(size: 13))
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    ChildProfileView()
            .environmentObject(
                ChildProfileViewModel()
            )
}

