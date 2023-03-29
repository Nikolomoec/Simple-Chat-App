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
    
    // Image Picker
    @State private var selectedImage: UIImage?
    @State private var isPickerShowing = false
    
    @State private var source: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var isSourceDialogShowing = false
    
    // Contacts Picker
    @State private var isContactPickerShowing = false
    
    var body: some View {
        VStack (spacing: 0) {
            // MARK: - Header
            ZStack {
                Color("backgroundScreen")
                    .ignoresSafeArea()
                    .frame(height: 109)
                HStack {
                    VStack(alignment: .leading) {
                        
                        HStack {
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
                            
                            if participants.count == 0 {
                                Text("New Message")
                                    .padding(.leading)
                                    .font(.nameTitle)
                            }
                        }
                        
                        if participants.count > 0 {
                            
                            let participant = participants.first
                            
                            // Title Name
                            Group {
                                if participants.count == 1 {
                                    
                                    Text("\(participant?.firstName ?? "") \(participant?.lastName ?? "")")
                                    
                                } else if participants.count == 2 {
                                    
                                    let participant2 = participants[1]
                                    
                                    Text("\(participant?.firstName ?? ""), \(participant2.firstName ?? "")")
                                    
                                } else if participants.count > 2 {
                                    
                                    let participant2 = participants[1]
                                    
                                    Text("\(participant?.firstName ?? ""), \(participant2.firstName ?? "") + \(participants.count - 2) others")
                                    
                                }
                            }
                            .font(.nameTitle)
                            .padding(.top, 10)
                        } else {
                            Text("Recipient")
                                .font(.chatTextField)
                                .foregroundColor(Color("searchBarText"))
                        }
                    }
                    
                    Spacer()
                    
                    if participants.count == 1 {
                        
                        let participant = participants.first
                        
                        // Title profile image for a single user
                        ProfileImageView(user: participant!)
                        
                    } else if participants.count > 1 {
                        // Title profile image for a group chats
                        GroupProfileImageView(users: participants)
                    } else {
                        // New Message
                        Button {
                            // Show Contact Picker
                            isContactPickerShowing = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .tint(Color("textBubble"))
                        }
                    }
                }
                .padding(.trailing, 36)
                .padding(.leading, 16)
            }
            // MARK: - Main Chat
            ScrollViewReader { proxy in
                ZStack {
                    // Background color of chat flow
                    Color("secondBack")
                    
                    // Chat flow
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
                                    } else if participants.count > 1 {
                                        // If this is group chat display user profile image
                                        let userOfMsg = participants.filter({ $0.id == msg.senderId }).first
                                        
                                        if let userOfMsg = userOfMsg {
                                            ProfileImageView(user: userOfMsg)
                                                .padding(.trailing, 16)
                                        }
                                    }
                                    
                                    if msg.imageurl == "" {
                                        // Text Message
                                        
                                        // Determine if this is a group chat and a msg from another user
                                        if participants.count > 1 && !isFromUser {
                                            // Find user name
                                            let userOfMsg = participants.filter({ $0.id == msg.senderId }).first
                                            
                                            // Show a text msg with name
                                            ConversationTextMesage(msg: msg.msg,
                                                                   isFromUser: isFromUser,
                                                                   name: "\(userOfMsg?.firstName ?? "") \(userOfMsg?.lastName)")
                                        } else {
                                            // Text msg with no name
                                            ConversationTextMesage(msg: msg.msg,
                                                                   isFromUser: isFromUser)
                                        }
                                    } else {
                                        // Image Message
                                        ConversationPhotoMessage(imageUrl: msg.imageurl!,
                                                                 isFromUser: isFromUser)
                                    }
                                    
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
                }
                .onAppear {
                    proxy.scrollTo(chatModel.messages.count - 1)
                }
                .onChange(of: chatModel.messages.count) { newCount in
                    withAnimation {
                        proxy.scrollTo(newCount - 1)
                    }
                }
            }
            if participants.count > 0 {
                // MARK: - Footer
                ZStack {
                    Color("secondBack")
                        .ignoresSafeArea()
                        .frame(height: 85)
                    HStack() {
                        
                        // Picker Photo Button
                        Button {
                            isSourceDialogShowing = true
                        } label: {
                            Image(systemName: "camera.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 33, height: 33)
                                .foregroundColor(Color("textBubble"))
                        }
                        
                        // TextField
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: 270, height: 44)
                                .foregroundColor(Color("searchBar"))
                            
                            if selectedImage == nil {
                                TextField("Aa", text: $message)
                                    .padding(10)
                                    .padding(.leading, 7)
                                    .font(.chatTextField)
                            } else {
                                Text("Image")
                                    .padding(10)
                                    .padding(.leading, 7)
                                    .font(.chatTextField)
                                    .foregroundColor(Color("searchBarText"))
                                
                                HStack {
                                    Spacer()
                                    
                                    Button {
                                        // Delete button
                                        selectedImage = nil
                                    } label: {
                                        Image(systemName: "multiply.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(Color("systemIcons"))
                                    }
                                    .padding(.trailing, 12)
                                }
                            }
                        }
                        .padding(.horizontal, 13.5)
                        
                        // Send Button
                        Button {
                            // Check if image is selected, if so send an image
                            if selectedImage != nil {
                                
                                // Send Image message
                                chatModel.sendImage(image: selectedImage!)
                                
                                // Clear image
                                selectedImage = nil
                                
                            } else {
                                // Send message
                                chatModel.sendMessage(msg: message)
                                
                                // Clear TextField
                                message = ""
                            }
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 33, height: 33)
                                .foregroundColor(Color("textBubble"))
                        }
                        .disabled(message.trimmingCharacters(in: .whitespacesAndNewlines) == "" && selectedImage == nil)
                        
                    }
                    .padding(.horizontal, 30)
                }
            }
        }
        // MARK: - All ZStack Modifiers
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
        .confirmationDialog("From where?", isPresented: $isSourceDialogShowing, actions: {
            
            // Set the source to image library
            // Show the image picker
            Button {
                
                self.source = .photoLibrary
                isPickerShowing = true
                
            } label: {
                Text("Photo Library")
            }
            
            // Set the source to camera
            // Show the image picker
            Button {
                
                self.source = .camera
                isPickerShowing = true
                
            } label: {
                Text("Take Photo")
            }
            
            
        })
        .sheet(isPresented: $isPickerShowing) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing, source: self.source)
        }
        .sheet(isPresented: $isContactPickerShowing) {
            // When user dismis view, search the conversation with selected participants
            if let participant = participants.first {
                chatModel.getChatFor(contacts: participants)
            }
            
        } content: {
            ContactPicker(selectedContacts: $participants, isContactPickerShowing: $isContactPickerShowing)
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
