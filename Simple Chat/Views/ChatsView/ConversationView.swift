//
//  ConversationView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 22.03.2023.
//

import SwiftUI

struct ConversationView: View {
    
    @Binding var isChatShowing: Bool
    
    @State private var message = ""
    
    @EnvironmentObject var chatModel: ChatViewModel
    @EnvironmentObject var contactModel: ContactsViewModel
    
    @State var participants = [User]()
    
    var body: some View {
        VStack (spacing: 0) {
            // Header
            ZStack {
                Color("backgroundScreen")
                    .ignoresSafeArea()
                    .frame(height: 109)
                HStack {
                    VStack(alignment: .leading) {
                        
                        Button {
                            isChatShowing.toggle()
                        } label: {
                            Image(systemName: "arrow.backward")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                                .padding(.leading, 10)
                        }
                        
                        if participants.count > 0 {
                            
                            let participant = participants.first
                            
                            // Title Name
                            Text("\(participant?.firstName ?? "") \(participant?.lastName ?? "")")
                                .font(.nameTitle)
                                .padding(.top, 10)
                        }
                    }
                    
                    Spacer()
                    
                    if participants.count > 0 {
                        
                        let participant = participants.first
                        
                        // Title profile image
                        ProfileImageView(user: participant!)
                        
                    }
                }
                .padding(.trailing, 36)
                .padding(.leading, 16)
            }
            // Chat
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 24) {
                        
                        ForEach (Array(chatModel.messages.enumerated()), id: \.element) { index, msg in
                            // Dynamic Message
                            
                            let isFromUser = msg.senderId == AuthViewModel.getLoggedInUserId()
                            
                            HStack {
                                
                                if isFromUser {
                                    
                                    Text(DateHelper.chatTimestampFrom(date: msg.timestamp))
                                        .font(.chatDate_Time)
                                        .padding(.trailing)
                                    
                                    Spacer()
                                }
                                
                                Text(msg.msg)
                                    .font(.message)
                                    .foregroundColor(isFromUser ? .white : .black)
                                    .padding(.vertical, 16)
                                    .padding(.horizontal, 24)
                                    .background(isFromUser ? Color("textBubble") : Color("searchBar"))
                                    .cornerRadius(30, corners: isFromUser ? [.bottomLeft,.topLeft,.topRight] : [.bottomRight,.topLeft,.topRight])
                                
                                if !isFromUser {
                                    Spacer()
                                    
                                    Text(DateHelper.chatTimestampFrom(date: msg.timestamp))
                                        .font(.chatDate_Time)
                                        .padding(.trailing)
                                }
                            }
                            .padding(.horizontal)
                            .id(index)
                        }
                    }
                    .padding(.top)
                }
                .onChange(of: chatModel.messages.count) { newCount in
                    withAnimation {
                        proxy.scrollTo(newCount - 1)
                    }
                }
            }
            // Message bar
            ZStack {
                Color.white
                    .ignoresSafeArea()
                    .frame(height: 85)
                HStack() {
                    
                    // Picker Photo Button
                    Button {
                        
                    } label: {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 33, height: 33)
                            .foregroundColor(Color("secondaryText"))
                    }
                    
                    // TextField
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 270, height: 44)
                            .foregroundColor(Color("searchBar"))
                        TextField("Aa", text: $message)
                            .padding(10)
                            .padding(.leading, 7)
                            .font(.chatTextField)
                        HStack {
                            Spacer()
                            
                            Button {
                                // Emoji picker
                                
                            } label: {
                                Image(systemName: "face.smiling")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(Color("systemIcons"))
                            }
                            .padding(.trailing, 12)
                        }

                    }
                    .padding(.horizontal, 13.5)
                    
                    // Send Button
                    Button {
                        // Clean Up text msg
                        
                        // Send message
                        chatModel.sendMessage(msg: message)
                        
                        // Clear TextField
                        message = ""
                        
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 33, height: 33)
                            .foregroundColor(Color("textBubble"))
                    }

                }
                .padding(.horizontal, 30)
            }
        }
        .onAppear {
            // Call chatModel to retrieve all messages
            chatModel.getMessages()
            
            // Try to get other participants as User instances
            let ids = chatModel.getParticipantIds()
            self.participants = contactModel.getParticipants(ids: ids)
        }
        .onDisappear {
            chatModel.closeConverstionViewListeners()
        }
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView(isChatShowing: .constant(true))
            .environmentObject(ChatViewModel())
            .environmentObject(ContactsViewModel())
    }
}
