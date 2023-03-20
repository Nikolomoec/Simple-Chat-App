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
    
    var body: some View {
        
        ZStack {
            
            Color("backgroundScreen")
                .ignoresSafeArea(edges: [.top, .bottom])
            
            switch currentStep {
                
            case .welcome:
                WelcomeView(currentStep: $currentStep)
                
            case .phone:
                PhoneNumberView()
                
            case .verification:
                AuthView()
                
            case .profile:
                CreateProfileView()
                
            case .contacts:
                SyncContactsView()
                
            }
        }
        
    }
}

struct OnboardingContainerView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContainerView()
    }
}
