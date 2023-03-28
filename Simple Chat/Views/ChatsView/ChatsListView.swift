//
//  ChatsListView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 21.03.2023.
//

import SwiftUI

struct ChatsListView: View {
    
    @EnvironmentObject var chatModel: ChatViewModel
    @EnvironmentObject var contactsModel: ContactsViewModel
    
    @Binding var isChatShowing: Bool
    
    @Binding var isSettingsShowing: Bool
    
    var body: some View {
        
        VStack {
            
            HStack {
                Text("Chats")
                    .font(.chat_contactsTitle)
                
                Spacer()
                
                Button {
                // Open Settings
                    isSettingsShowing = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .tint(.black)
                        .scaledToFill()
                        .frame(width: 26, height: 26)
                }
                
            }
            .padding(.horizontal, 35)
            .padding(.top, 16)
            
            if chatModel.chats.count > 0 {
                
                List(chatModel.chats) { chat in
                    Button {
                        // Set selected chat for the chatViewModel
                        chatModel.selectedChat = chat
                        
                        // Display ConversationView
                        isChatShowing = true
                        
                    } label: {
                        ChatListRow(chat: chat, otherParticipants: contactsModel.getParticipants(ids: chat.chats))
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .buttonStyle(.plain)
                }
                .listStyle(.plain)
                
            } else {
                Spacer()
                
                VStack {
                    
                    Image("noChats")
                        .resizable()
                        .frame(width: 284, height: 270)
                    
                    VStack {
                        Text("Hmm... no chats yet  :(")
                            .font(.noChats_noContactsTitle)
                            .padding(.bottom, 2)
                        Text("Message a friend to get started!")
                            .font(.noChats_noContactsDesc)
                    }
                    .foregroundColor(Color("secondaryText"))
                    .multilineTextAlignment(.center)
                }
                .padding()
                .padding(.bottom, 90)
                
                
                Spacer()
            }
        }
    }
}

struct ChatsListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsListView(isChatShowing: .constant(true), isSettingsShowing: .constant(false))
            .environmentObject(ChatViewModel())
            .environmentObject(ContactsViewModel())
    }
}
