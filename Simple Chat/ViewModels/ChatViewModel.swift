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
    
    init() {
        // Retrieve chats when ChatViewModel is created
        getChats()
    }
    
    // Use Databse Service to retrieve chats
    // Set the retrieved data to the chats property
    func getChats() {
        DatabaseService().getAllchats { chats in
            self.chats = chats
        }
    }
    
}
