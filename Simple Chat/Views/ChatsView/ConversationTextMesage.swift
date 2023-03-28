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
    var name: String?
    
    var body: some View {
        VStack (alignment: .leading, spacing: 4) {
            // Name
            if let name = name {
                Text(name)
                    .foregroundColor(Color("textBubble"))
            }
            
            // Text
            Text(msg)
                .foregroundColor(isFromUser ? .white : .black)
        }
        .font(.message)
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
        .background(isFromUser ? Color("textBubble") : Color("searchBar"))
        .cornerRadius(30, corners: isFromUser ? [.bottomLeft,.topLeft,.topRight] : [.bottomRight,.topLeft,.topRight])
    }
}

struct ConversationTextMesage_Previews: PreviewProvider {
    static var previews: some View {
        ConversationTextMesage(msg: "message", isFromUser: true, name: "Kate")
    }
}
