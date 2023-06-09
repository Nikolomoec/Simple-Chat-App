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
    
    @State private var isButtonDisabled = false
    
    @State private var isErrorShowing = false
    
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
            .foregroundColor(Color("onboarding"))
            .multilineTextAlignment(.center)
            
            // PhoneNumber TextField
            ZStack {
                
                Rectangle()
                    .frame(height: 56)
                    .foregroundColor(Color("searchBar"))
                
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
            
            // Error label
            Text("Please enter a valid phone number.")
                .foregroundColor(.red)
                .font(.verificationDesc_numberPlaceHolder)
                .padding(.top, 20)
                .opacity(isErrorShowing ? 1 : 0)
            
            Spacer()
            
            Button {
                isButtonDisabled = true
                isErrorShowing = false
                
                // Send their phone number to firebase Auth
                AuthViewModel.sendPhoneNumber(phone: phoneNumber) { error in
                    if error == nil {
                        // Move to the next screen
                        currentStep = .verification
                    } else {
                        // Show an error
                        isErrorShowing = true
                    }
                    isButtonDisabled = false
                }
            } label: {
                HStack {
                    Text("Next")
                    
                    if isButtonDisabled {
                        ProgressView()
                            .padding(.leading, 4)
                    }
                }
            }
            .disabled(isButtonDisabled)
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
