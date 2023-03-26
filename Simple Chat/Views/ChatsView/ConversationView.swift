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
            // Header
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
                            Text("\(participant?.firstName ?? "") \(participant?.lastName ?? "")")
                                .font(.nameTitle)
                                .padding(.top, 10)
                        } else {
                            Text("Recipient")
                                .font(.chatTextField)
                                .foregroundColor(Color("searchBarText"))
                        }
                    }
                    
                    Spacer()
                    
                    if participants.count > 0 {
                        
                        let participant = participants.first
                        
                        // Title profile image
                        ProfileImageView(user: participant!)
                        
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
                                if msg.imageurl == "" {
                                    // Text Message
                                    ConversationTextMesage(msg: msg.msg, isFromUser: isFromUser)
                                } else {
                                    // Image Message
                                    ConversationPhotoMessage(imageUrl: msg.imageurl!, isFromUser: isFromUser)
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
                // Message bar
                ZStack {
                    Color.white
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
                                .foregroundColor(Color("secondaryText"))
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
            // When user dismis view, search the conversation with selected participant
            if let participant = participants.first {
                chatModel.getChatFor(contact: participant)
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
