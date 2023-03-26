//
//  ConversationTextMesage.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 26.03.2023.
//

import SwiftUI

struct ConversationTextMesage: View {
    
    var msg: String
    var isFromUser: Bool
    
    var body: some View {
        Text(msg)
            .font(.message)
            .foregroundColor(isFromUser ? .white : .black)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .background(isFromUser ? Color("textBubble") : Color("searchBar"))
            .cornerRadius(30, corners: isFromUser ? [.bottomLeft,.topLeft,.topRight] : [.bottomRight,.topLeft,.topRight])
    }
}

struct ConversationTextMesage_Previews: PreviewProvider {
    static var previews: some View {
        ConversationTextMesage(msg: "message", isFromUser: true)
    }
}
