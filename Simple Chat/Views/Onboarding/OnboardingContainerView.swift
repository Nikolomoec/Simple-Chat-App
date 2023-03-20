//
//  OnboardingContainerView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 20.03.2023.
//

import SwiftUI

enum Onboarding: Int {
    case welcome = 0
    case phone = 1
    case verification = 2
    case profile = 3
    case contacts = 4
}

struct OnboardingContainerView: View {
    
    @State private var currentStep: Onboarding = .welcome
    
    @Binding var isOnboarding: Bool
    
    var body: some View {
        
        ZStack {
            
            Color("backgroundScreen")
                .ignoresSafeArea(edges: [.top, .bottom])
            
            switch currentStep {
                
            case .welcome:
                WelcomeView(currentStep: $currentStep)
                
            case .phone:
                PhoneNumberView(currentStep: $currentStep)
                
            case .verification:
                AuthView(currentStep: $currentStep)
                
            case .profile:
                CreateProfileView(currentStep: $currentStep)
                
            case .contacts:
                SyncContactsView(isOnboarding: $isOnboarding)
                
            }
        }
        
    }
}

struct OnboardingContainerView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContainerView(isOnboarding: .constant(true))
    }
}
