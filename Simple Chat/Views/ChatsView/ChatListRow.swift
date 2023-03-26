//
//  ChatListRow.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 24.03.2023.
//

import SwiftUI

struct ChatListRow: View {
    
    var chat: Chat
    
    var otherParticipants: [User]?
    
    var body: some View {
        HStack(spacing: 24) {
            
            let participant = otherParticipants?.first
            // Profile Image
            if let participant = participant {
                ProfileImageView(user: participant)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                // Name
                if let otherParticipants = otherParticipants {
                    Group {
                        if otherParticipants.count == 1 {
                            
                            Text("\(participant?.firstName ?? "Unkown") \(participant?.lastName ?? "")")
                            
                        } else if otherParticipants.count == 2 {
                            
                            let participant2 = otherParticipants[1]
                            
                            Text("\(participant?.firstName ?? "Unkown"), \(participant2.firstName ?? "")")
                            
                        } else if otherParticipants.count > 2 {
                            
                            let participant2 = otherParticipants[1]
                            
                            Text("\(participant?.firstName ?? "Unkown") \(participant2.firstName ?? "") + \(otherParticipants.count - 2) others")
                            
                        }
                    }
                    .font(.namePreview)
                }
                // Last Message
                Text(chat.lastmsg ?? "")
                    .font(.message)
                    .foregroundColor(Color("searchBarText"))
            }
            
            Spacer()
            if let lastMsgTime = chat.updated {
                Text(DateHelper.chatTimestampFrom(date: lastMsgTime))
                    .font(.chatDate_Time)
                    .padding(.trailing)
            }
        }
    }
}
