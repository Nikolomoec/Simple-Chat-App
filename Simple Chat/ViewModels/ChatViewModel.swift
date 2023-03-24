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
    
}
