//
//  ChatViewModel.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 24.03.2023.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject {
    
    @Published var chats = [Chat]()
    
    @Published var selectedChat: Chat?
    
    @Published var messages = [ChatMessage]()
    
    let dataService = DatabaseService()
    
    init() {
        // Retrieve chats when ChatViewModel is created
        getChats()
    }
    
    // Use Databse Service to retrieve chats
    // Set the retrieved data to the chats property
    func getChats() {
        dataService.getAllchats { chats in
            self.chats = chats
        }
    }
    
    /// Search for chat with past in user, if found set as selected chat, if not found create chat
    func getChatFor(contact: User) {
        // Check the user
        guard contact.id != nil else { return }
        
        let foundChat = chats.filter({ $0.numchats == 2 && $0.chats.contains(contact.id!) })
        
        // Found a chat between the user and a contact
        if !foundChat.isEmpty {
            // Set a selectedChat
            self.selectedChat = foundChat.first!
            
            // Fetch the messages
            getMessages()
            
        } else {
            // Create a new one
            var newChat = Chat(id: nil,
                               lastmsg: nil,
                               numchats: 2,
                               updated: nil,
                               chats: [AuthViewModel.getLoggedInUserId(),contact.id!],
                               msgs: nil)
            
            // Set as selectedChat
            self.selectedChat = newChat
            
            // Save new chat to the database
            dataService.createChat(chat: newChat) { docId in
                // Set the docId to the new chat
                self.selectedChat = Chat(id: docId,
                                         lastmsg: nil,
                                         numchats: 2,
                                         updated: nil,
                                         chats: [AuthViewModel.getLoggedInUserId(),contact.id!],
                                         msgs: nil)
                
                // Add new chat to the chat list
                self.chats.append(self.selectedChat!)
            }
        }
    }
    
    func getMessages() {
        
        guard selectedChat != nil else { return }
        
        dataService.getAllMessages(chat: selectedChat!) { msgs in
            self.messages = msgs
        }
    }
    
    func sendMessage(msg: String) {
        guard selectedChat != nil else { return }
        
        dataService.sendMessage(msg: msg, chat: selectedChat!)
    }
    
    func closeConverstionViewListeners() {
        dataService.detachConversationViewListeners()
    }
    
    func closeChatListViewListeners() {
        dataService.detachChatListViewListeners()
    }
    
    // MARK: - Helper Methods
    
    /// Takes a array of user Ids, remove the user that logged in and returns the array without user
    func getParticipantIds() -> [String] {
        
        guard selectedChat != nil else { return [String]() }
        
        return selectedChat!.chats.filter({ $0 !=  AuthViewModel.getLoggedInUserId()})
    }
}
