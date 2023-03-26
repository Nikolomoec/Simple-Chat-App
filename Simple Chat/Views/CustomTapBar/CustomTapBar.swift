//
//  CustomTapBar.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 18.03.2023.
//

import SwiftUI

enum Tabs: Int {
    case chats = 0
    case contacts = 1
}

struct CustomTapBar: View {
    
    @Binding var selectedTab: Tabs
    @Binding var isChatShowing: Bool
    
    @EnvironmentObject var chatModel: ChatViewModel
    
    var body: some View {
        
        HStack {
            
            Button {
                selectedTab = .contacts
                
            } label: {
                TabBarButton(image: "person", name: "Contacts", isActive: selectedTab == .contacts)
            }
            
            Button {
                // Clear the selected chat
                chatModel.clearSelectedChat()
                
                // Create New Chat View
                isChatShowing = true
                
            } label: {
                    
                    VStack(alignment: .center, spacing: 4) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                        Text("New Chat")
                            .font(Font.tapBar)
                    }
                    .foregroundColor(Color("textBubble"))
            }
            
            Button {
                selectedTab = .chats
            } label: {
                TabBarButton(image: "bubble.left", name: "Chats", isActive: selectedTab == .chats)
            }
            
        }
        .frame(height: 98)
    }
}

struct CustomTapBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTapBar(selectedTab: .constant(.contacts), isChatShowing: .constant(true))
            .environmentObject(ChatViewModel())
    }
}
