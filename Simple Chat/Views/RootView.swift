//
//  ContentView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 18.03.2023.
//

import SwiftUI

struct RootView: View {
    
    @State var selectedTab: Tabs = .contacts
    
    @State var isOnboarding = !AuthViewModel.isUserLoggedIn()
    
    @State var isChatShowing = false
    
    var body: some View {
        ZStack {
            Color("backgroundScreen")
                .ignoresSafeArea()
            VStack {
                
                switch selectedTab {
                case .chats:
                    ChatsListView(isChatShowing: $isChatShowing)
                case .contacts:
                    ContactsListView(isChatShowing: $isChatShowing)
                }
                
                Spacer()
                
                CustomTapBar(selectedTab: $selectedTab)
                
            }
        }
        .fullScreenCover(isPresented: $isOnboarding) {
            
        } content: {
            OnboardingContainerView(isOnboarding: $isOnboarding)
        }
        .fullScreenCover(isPresented: $isChatShowing, onDismiss: nil) {
            ConversationView(isChatShowing: $isChatShowing)
        }

    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
