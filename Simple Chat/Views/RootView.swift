//
//  ContentView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 18.03.2023.
//

import SwiftUI

struct RootView: View {
    
    // For detenting when app is will be on the background
    @Environment(\.scenePhase) var scenePhase
    
    @State var selectedTab: Tabs = .contacts
    
    @State var isOnboarding = !AuthViewModel.isUserLoggedIn()
    
    @State var isChatShowing = false
    
    @EnvironmentObject var contactsModel: ContactsViewModel
    @EnvironmentObject var chatModel: ChatViewModel
    
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
                
                CustomTapBar(selectedTab: $selectedTab, isChatShowing: $isChatShowing)
                
            }
        }
        .onAppear {
            if !isOnboarding {
                // User has already onboarded, load contacts
                contactsModel.getLocalContacts()
            }
        }
        .fullScreenCover(isPresented: $isOnboarding) {
            
        } content: {
            OnboardingContainerView(isOnboarding: $isOnboarding)
        }
        .fullScreenCover(isPresented: $isChatShowing, onDismiss: nil) {
            ConversationView(isChatShowing: $isChatShowing)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                chatModel.closeChatListViewListeners()
            }
        }

    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(ChatViewModel())
            .environmentObject(ContactsViewModel())
    }
}
