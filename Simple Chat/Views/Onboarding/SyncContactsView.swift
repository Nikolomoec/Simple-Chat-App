//
//  SyncContactsView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 20.03.2023.
//

import SwiftUI

struct SyncContactsView: View {
    
    @Binding var isOnboarding: Bool
    
    var body: some View {
        VStack {
            
            Image("setup")
                .resizable()
                .frame(width: 289, height: 308)
                .padding(.top, 73)
                .padding(.bottom, 28)
            
            VStack {
                Text("You’re all set!")
                    .font(.startTitle)
                    .padding(.bottom, 25)
                    .padding(.horizontal, 50)
                Text("Continue to start chatting with your friends.")
                    .font(.startDesc)
            }
            .foregroundColor(Color("secondaryText"))
            .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                isOnboarding = false
            } label: {
                Text("Continue")
            }
            .buttonStyle(StartButtonStyle())
            .padding(.bottom, 77)
        }
    }
}

struct SyncContactsView_Previews: PreviewProvider {
    static var previews: some View {
        SyncContactsView(isOnboarding: .constant(true))
    }
}
