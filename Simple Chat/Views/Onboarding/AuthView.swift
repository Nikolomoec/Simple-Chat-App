//
//  AuthView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 20.03.2023.
//

import SwiftUI
import Combine

struct AuthView: View {
    
    @Binding var currentStep: Onboarding
    @Binding var isOnboarding: Bool
    
    @State private var authCode = ""
    @State private var isButtonTapped = false
    @State private var isErrorShowing = false
    
    @EnvironmentObject var contactsModel: ContactsViewModel
    @EnvironmentObject var chatsModel: ChatViewModel
    
    var body: some View {
        VStack {
            
            VStack {
                
                Text("Verification")
                    .font(.verificationTitle)
                    .padding(.top, 40)
                
                Text("We sent a 6-digit verification code to your device.")
                    .font(.verificationDesc_numberPlaceHolder)
                    .padding(.top, 24)
                    .padding(.horizontal, 39)
                    .padding(.bottom, 34)
            }
            .foregroundColor(Color("onboarding"))
            .multilineTextAlignment(.center)
            
            ZStack {
                
                Rectangle()
                    .frame(height: 56)
                    .foregroundColor(Color("searchBar"))
                
                HStack {
                    TextField("", text: $authCode)
                        .keyboardType(.numberPad)
                        .onReceive(Just(authCode)) { _ in
                            TextHelper.limitText(&authCode, 6)
                        }
                    
                    Spacer()
                    
                    Button {
                        authCode = ""
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
            Text("Invalid verification code")
                .foregroundColor(.red)
                .font(.verificationDesc_numberPlaceHolder)
                .padding(.top, 20)
                .opacity(isErrorShowing ? 1 : 0)
            
            Spacer()
            
            Button {
                
                isButtonTapped = true
                isErrorShowing = false
                
                // Send the verification code to Firebase
                AuthViewModel.verifyCode(code: authCode) { error in
                    if error == nil {
                        
                        // Check if user have profile
                        DatabaseService().checkUserProfile { exists in
                            if exists {
                                isOnboarding = false
                                
                                // Fetch User Contacts, Chats
                                contactsModel.getLocalContacts()
                                chatsModel.getChats()
                                
                            } else {
                                // Move to the next step
                                currentStep = .profile
                            }
                        }
                    } else {
                        // Display an error
                        isErrorShowing = true
                    }
                    
                    isButtonTapped = false
                }
            } label: {
                HStack {
                    Text("Next")
                    
                    if isButtonTapped {
                        ProgressView()
                            .padding(.leading, 4)
                    }
                }
            }
            .disabled(isButtonTapped)
            .buttonStyle(StartButtonStyle())
            .padding(.bottom, 77)
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(currentStep: .constant(.verification), isOnboarding: .constant(true))
            .environmentObject(ContactsViewModel())
            .environmentObject(ChatViewModel())
    }
}
