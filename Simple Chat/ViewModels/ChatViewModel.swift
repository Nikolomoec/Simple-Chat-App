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
    
    /// Takes a array of user Ids, remove the user that logged in and returns the array without user
    func getParticipantIds() -> [String] {
        
        guard selectedChat != nil else { return [String]() }
        
        return selectedChat!.chats.filter({ $0 !=  AuthViewModel.getLoggedInUserId()})
    }
}
