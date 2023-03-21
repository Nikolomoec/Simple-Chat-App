//
//  ContentView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 18.03.2023.
//

import SwiftUI

struct RootView: View {
    
    @State var selectedTab: Tabs = .chats
    
    @State var isOnboarding = !AuthViewModel.isUserLoggedIn()
    
    var body: some View {
        ZStack {
            Color("backgroundScreen")
                .ignoresSafeArea()
            VStack {
                
                switch selectedTab {
                case .chats:
                    ChatsListView()
                case .contacts:
                    ContactsListView()
                }
                
                Spacer()
                
                CustomTapBar(selectedTab: $selectedTab)
                
            }
        }
        .fullScreenCover(isPresented: $isOnboarding) {
            
        } content: {
            OnboardingContainerView(isOnboarding: $isOnboarding)
        }

    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
