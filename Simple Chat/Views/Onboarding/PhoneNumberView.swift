//
//  PhoneNumberView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 20.03.2023.
//

import SwiftUI
import Combine

struct PhoneNumberView: View {
    
    @Binding var currentStep: Onboarding
    
    @State private var phoneNumber = ""
    
    var body: some View {
        
        VStack {
            
            VStack {
                
                Text("Verification")
                    .font(.verificationTitle)
                    .padding(.top, 40)
                
                Text("Enter your mobile number below. We’ll send you a verification code after.")
                    .font(.verificationDesc_numberPlaceHolder)
                    .padding(.top, 24)
                    .padding(.horizontal, 39)
                    .padding(.bottom, 34)
            }
            .foregroundColor(Color("secondaryText"))
            .multilineTextAlignment(.center)
            
            // PhoneNumber TextField
            ZStack {
                
                Rectangle()
                    .frame(height: 56)
                    .foregroundColor(Color("TextField"))
                
                HStack {
                    TextField("e.g. +1 613 515 0123", text: $phoneNumber)
                        .keyboardType(.numberPad)
                        .onReceive(Just(phoneNumber)) { _ in
                            TextHelper.applyPatternOnNumbers(&phoneNumber, pattern: "+## (###) ###-####", replacementCharacter: "#")
                        }
                    
                    Spacer()
                    
                    Button {
                        phoneNumber = ""
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .frame(width: 24, height: 24)
                            .tint(Color("systemIcons"))
                    }

                }
                .padding(16)
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                // Send their phone number to firebase Auth
                AuthViewModel.sendPhoneNumber(phone: phoneNumber) { error in
                    if error == nil {
                        // Move to the next screen
                        currentStep = .verification
                    } else {
                        // Show an error
                        
                    }
                }
            } label: {
                Text("Next")
            }
            .buttonStyle(StartButtonStyle())
            .padding(.bottom, 77)
        }
    }
}

struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView(currentStep: .constant(.verification))
    }
}
