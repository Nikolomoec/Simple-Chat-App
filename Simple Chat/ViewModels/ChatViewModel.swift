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
    
    func clearSelectedChat() {
        self.selectedChat = nil
        self.messages.removeAll()
    }
    
    // Use Databse Service to retrieve chats
    // Set the retrieved data to the chats property
    func getChats() {
        dataService.getAllchats { chats in
            self.chats = chats
        }
    }
    
    /// Search for chat with past in users, if found set as selected chat, if not found create chat
    func getChatFor(contacts: [User]) {
        // Check the user
        for contact in contacts {
            guard contact.id != nil else { return }
        }
        
        // Create a set from the ids of the contacts passed in
        let setOfContactIds = Set(arrayLiteral: contacts.map { $0.id! })
        
        let foundChat = chats.filter { chat in
            let setOfParticipantIds = Set(arrayLiteral: chat.chats)
            
            return chat.numchats == contacts.count + 1 && setOfContactIds.isSubset(of: setOfParticipantIds)
        }
        
        // Found a chat between the users and a contacts
        if !foundChat.isEmpty {
            // Set a selectedChat
            self.selectedChat = foundChat.first!
            
            // Fetch the messages
            getMessages()
            
        } else {
            // Create a new one
            
            // Create array of ids of all participants
            var allParticipantIds = contacts.map { $0.id! }
            allParticipantIds.append(AuthViewModel.getLoggedInUserId())
            
            let newChat = Chat(id: nil,
                               lastmsg: nil,
                               numchats: allParticipantIds.count,
                               updated: nil,
                               chats: allParticipantIds,
                               msgs: nil)
            
            // Set as selectedChat
            self.selectedChat = newChat
            
            // Save new chat to the database
            dataService.createChat(chat: newChat) { docId in
                // Set the docId to the new chat
                self.selectedChat = Chat(id: docId,
                                         lastmsg: nil,
                                         numchats: allParticipantIds.count,
                                         updated: nil,
                                         chats: allParticipantIds,
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
    
    func sendImage(image: UIImage) {
        guard selectedChat != nil else { return }
        
        dataService.sendImage(image: image, chat: selectedChat!)
    }
    
    // MARK: - Helper Methods
    
    /// Takes a array of user Ids, remove the user that logged in and returns the array without user
    func getParticipantIds() -> [String] {
        
        guard selectedChat != nil else { return [String]() }
        
        return selectedChat!.chats.filter({ $0 !=  AuthViewModel.getLoggedInUserId()})
    }
}
