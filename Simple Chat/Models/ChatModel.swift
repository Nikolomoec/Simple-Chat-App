//
//  chatModel.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 24.03.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Chat: Codable, Identifiable {
    
    @DocumentID var id: String?
    
    var lastmsg: String?
    
    var numchats: Int
    
    @ServerTimestamp var updated: Date?
    
    var chats: [String]
    
    var msgs: [ChatMessage]?
    
}

struct ChatMessage: Codable, Identifiable {
    
    @DocumentID var id: String?
    
    var imageurl: String?
    
    var msg: String
    
    @ServerTimestamp var timestamp: Date?
    
    var senderId: String
}
