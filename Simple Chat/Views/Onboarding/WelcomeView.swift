//
//  WelcomeView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 20.03.2023.
//

import SwiftUI

struct WelcomeView: View {
    
    @Binding var currentStep: Onboarding
    
    var body: some View {
        VStack {
            
            Image("start")
                .resizable()
                .frame(width: 330, height: 250)
                .padding(.top, 73)
                .padding(.bottom, 28)
            
            VStack {
                Text("Welcome to Chat App")
                    .font(.startTitle)
                    .padding(.bottom, 25)
                    .padding(.horizontal, 50)
                Text("Most simple Chat app You will ever find!")
                    .font(.startDesc)
            }
            .foregroundColor(Color("secondaryText"))
            .multilineTextAlignment(.center)
            
            Spacer()
                Button {
                    currentStep = .phone
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 7)
                            .frame(width: 340, height: 55)
                            .foregroundColor(Color("primaryButton"))
                        Text("Continue")
                            .foregroundColor(Color("backgroundScreen"))
                            .font(.startButton)
                    }
                }
                .padding(.bottom, 5)
                
                Text("By tapping continue you agree to our Privacy Policy")
                    .font(.privacy)
                    .padding(.bottom, 43)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(currentStep: .constant(.welcome))
    }
}
