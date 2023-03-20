//
//  CreateProfileView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 20.03.2023.
//

import SwiftUI

struct CreateProfileView: View {
    
    @Binding var currentStep: Onboarding
    
    @State private var name = ""
    @State private var lastName = ""
    
    var body: some View {
        VStack {
            
            VStack {
                
                Text("Setup your Profile")
                    .font(.verificationTitle)
                    .padding(.top, 40)
                
                Text("Just a few more detailes to get started")
                    .font(.verificationDesc_numberPlaceHolder)
                    .padding(.top, 24)
                    .padding(.horizontal, 39)
                    .padding(.bottom, 34)
            }
            .foregroundColor(Color("secondaryText"))
            .multilineTextAlignment(.center)
            
            Spacer()
            
            // Profile Image
            ZStack {
                Circle()
                    .foregroundColor(Color("TextField"))
                Circle()
                    .stroke(Color("profileBorder"), lineWidth: 2)
                
                Image(systemName: "camera.fill")
                
            }
            .frame(width: 134, height: 134)
            
            Spacer()
            
            TextField("Given Name", text: $name)
                .textFieldStyle(CustomTextFieldStyle())
            
            TextField("Last Name", text: $lastName)
                .textFieldStyle(CustomTextFieldStyle())
            
            Spacer()
            
            Button {
                currentStep = .contacts
            } label: {
                Text("Next")
            }
            .buttonStyle(StartButtonStyle())
            .padding(.bottom, 77)
        }
        
    }
}

struct CreateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProfileView(currentStep: .constant(.profile))
    }
}
