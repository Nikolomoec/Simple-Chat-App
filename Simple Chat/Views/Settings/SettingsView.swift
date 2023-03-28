//
//  SettingsView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 28.03.2023.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var isDarkMode = false
    
    @Binding var isSettingsShowing: Bool
    @Binding var isOnboarding: Bool
    
    var body: some View {
        VStack {
            // Heading
            HStack(spacing: 200) {
                Text("Settings")
                    .font(.chat_contactsTitle)
                
                Button {
                    // Close settings View
                    isSettingsShowing = false
                    
                } label: {
                    Image(systemName: "multiply")
                        .resizable()
                        .tint(.black)
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 32)
            
            VStack (alignment: .leading, spacing: 40) {
                HStack {
                    Text("Dark Mode")
                        .font(.settings)
                        .tint(.black)
                    
                    Spacer()
                    
                    Toggle("", isOn: $isDarkMode)
                }
                
                Button {
                    // Log out
                    AuthViewModel.logout()
                    
                    // Return user to Onboarding sequence
                    isOnboarding = true
                    
                } label: {
                    Text("Log Out")
                        .font(.settings)
                }
                .tint(.black)

                Button {
                    // Delete user account
                    
                } label: {
                    Text("Delete account")
                        .font(.deleteButton)
                        .foregroundColor(Color("deleteButton"))
                }

            }
            .padding(.leading, 22)
            .padding(.trailing, 34)
            
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isSettingsShowing: .constant(true), isOnboarding: .constant(false))
    }
}
