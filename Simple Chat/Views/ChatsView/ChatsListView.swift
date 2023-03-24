//
//  ChatsListView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 21.03.2023.
//

import SwiftUI

struct ChatsListView: View {
    
    @EnvironmentObject var chatModel: ChatViewModel
    
    var body: some View {
        
        if chatModel.chats.count > 0 {
            
            List(chatModel.chats) { chat in
                Text(chat.id ?? "chat id is empry")
            }
            
        } else {
            // No chats
        }
        
    }
}

struct ChatsListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsListView()
            .environmentObject(ChatViewModel())
    }
}
