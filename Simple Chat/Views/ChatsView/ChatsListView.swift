//
//  ChatsListView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 21.03.2023.
//

import SwiftUI

struct ChatsListView: View {
    
    @EnvironmentObject var chatModel: ChatViewModel
    
    @Binding var isChatShowing: Bool
    
    var body: some View {
        
        if chatModel.chats.count > 0 {
            
            List(chatModel.chats) { chat in
                Button {
                    // Set selected chat for the chatViewModel
                    chatModel.selectedChat = chat
                    
                    // Display ConversationView
                    isChatShowing = true
                    
                } label: {
                    Text("chat1")
                }

            }
            
        } else {
            // No chats
            Text("No chats")
        }
        
    }
}

struct ChatsListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsListView(isChatShowing: .constant(true))
            .environmentObject(ChatViewModel())
    }
}
