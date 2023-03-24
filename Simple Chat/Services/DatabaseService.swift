//
//  DatabaseService.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 21.03.2023.
//

import Foundation
import Contacts
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift
import UIKit

class DatabaseService {
    
    var chatListViewListeners = [ListenerRegistration]()
    var conversationViewListeners = [ListenerRegistration]()
    
    func getPlatformUsers(localContacts: [CNContact], completion: @escaping ([User]) -> Void) {
        var platformUsers = [User]()
        
        // Transform whole contacts to just phoneNumber strings
        var phoneNumbers = localContacts.map { contact in
            return TextHelper.cleanPhoneNumber(contact.phoneNumbers.first?.value.stringValue ?? "")
        }
        
        // If we have 0 phone numbers just dont create database
        guard phoneNumbers.count > 0 else {
            completion(platformUsers)
            return
        }
        
        // Query Database for this phone numbers
        let db = Firestore.firestore()
        
        // Perform Querys while we still have numbers in phoneNumbers
        while !phoneNumbers.isEmpty {
            
            // Get the first 10 numbers to lookup
            let tenPhoneNumbers = Array(phoneNumbers.prefix(10))
            
            // Remove the first 10
            phoneNumbers = Array(phoneNumbers.dropFirst(10))
            
            // Lookup the first 10
            let query = db.collection("user").whereField("phone", in: tenPhoneNumbers)
            
            query.getDocuments { snapshot, error in
                if error == nil && snapshot != nil {
                    // For Each Doc that was fetched create an User
                    for doc in snapshot!.documents {
                        if let user = try? doc.data(as: User.self) {
                            platformUsers.append(user)
                        }
                    }
                    if phoneNumbers.isEmpty {
                        completion(platformUsers)
                    }
                }
            }
        }
    }
    
    func setUserProfile(firstName: String, lastName: String, image: UIImage?, completion: @escaping(Bool) -> Void) {
        
        // Insure that user is logged in
        guard AuthViewModel.isUserLoggedIn() != false else { return }
        
        let userPhone = TextHelper.cleanPhoneNumber(AuthViewModel.getLoggedinUserPhone())
        // Reference to the Firestore
        let db = Firestore.firestore()
        
        // Set the profile data
        let doc = db.collection("user").document(AuthViewModel.getLoggedInUserId())
        doc.setData(["firstName" : firstName,
                     "lastName"  : lastName,
                     "phone"     : userPhone])
        // Check if image is not nil
        
        if let image = image {
            
            // Create storage references
            let storageRef = Storage.storage().reference()
            
            // Turn our image into data
            let imageData = image.jpegData(compressionQuality: 0.8)
            
            // Check if we are able to convert it into data
            guard imageData != nil else { return }
            
            // Specify file path and name
            let path = "images/\(UUID().uuidString).jpg"
            let fileRef = storageRef.child(path)
            
            let uploadTask = fileRef.putData(imageData!) { meta, error in
                if error == nil && meta != nil {
                    
                    // Get full Url to image
                    fileRef.downloadURL { url, error in
                        
                        if url != nil && error == nil {
                            // Set the image data to profile
                            
                            // We are using "merge: true" bc we want it
                            // to update the user profile not to override it
                            doc.setData(["photo": url!.absoluteString], merge: true) { error in
                                if error == nil {
                                    // Sucsess, notify user
                                    completion(true)
                                }
                            }
                        } else {
                            // Not sucscess to getting url
                            completion(false)
                        }
                    }
                    
                } else {
                    completion(false)
                }
            }
        } else {
            // No image is set
            completion(true)
        }
    }
    
    func checkUserProfile(completion: @escaping (Bool) -> Void) {
        
        guard AuthViewModel.isUserLoggedIn() != false else { return }
        
        // Create firebase ref
        let db = Firestore.firestore()
        db.collection("users").document(AuthViewModel.getLoggedInUserId())
            .getDocument { snapshot, error in
                if snapshot != nil && error == nil {
                    
                    // Notify that profile exists
                    completion(snapshot!.exists)
                } else {
                    completion(false)
                }
            }
        
    }
    
    // MARK: - Chat Methods
    
    /// This method returns all chat documents where the logged in user is a participant
    func getAllchats(completion: @escaping ([Chat]) -> Void) {
        
        // Ref ro the database
        let db = Firestore.firestore()
        
        // Perform a chat query against the chat collection where users are participants
        let chatsQuery = db.collection("chats")
            .whereField("chats", arrayContains: AuthViewModel.getLoggedInUserId())
        
        let listener = chatsQuery.addSnapshotListener { snapshot, error in
            if error == nil && snapshot != nil {
                
                var chats = [Chat]()
                
                // Loop through all returned chat docs
                for doc in snapshot!.documents {
                    
                    // Parse data into our chat structures
                    let chat = try? doc.data(as: Chat.self)
                    
                    if let chat = chat {
                        chats.append(chat)
                    }
                }
                // Return the Data
                completion(chats)
            } else {
                print("Error in database retrival")
            }
        }
        
        // Keep track of the listener so we can close it later
        chatListViewListeners.append(listener)
        
    }
    
    /// This method returns all messages for a given chat
    func getAllMessages(chat: Chat, completion: @escaping ([ChatMessage]) -> Void) {
        
        // Check if chat id is not nil
        if let chatId = chat.id {
            // Get a ref to database
            let db = Firestore.firestore()
            
            // Create the query
            let msgQuery = db.collection("chats")
                .document(chatId)
                .collection("msgs")
                .order(by: "timestamp")
            
            // Perform the query
            let listener = msgQuery.addSnapshotListener { snapshot, error in
                
                var messages = [ChatMessage]()
                
                if snapshot != nil && error == nil {
                    for doc in snapshot!.documents {
                        let message = try? doc.data(as: ChatMessage.self)
                        
                        if let message = message {
                            messages.append(message)
                        }
                    }
                    // Return the results
                    completion(messages)
                }
                else {
                    print("Error in database retrival")
                }
            }
            
            // Keep track of the listener so we can close it later
            conversationViewListeners.append(listener)
            
        } else {
            completion([ChatMessage]())
        }
    }
    
    /// Send a message to the database
    func sendMessage(msg: String, chat: Chat) {
        
        // Check if it's valid chat
        guard chat.id != nil else { return }
        
        // Get a reference to database
        let db = Firestore.firestore()
        
        // Add msg document
        db.collection("chats")
            .document(chat.id!)
            .collection("msgs")
            .addDocument(data: ["imageurl" : "",
                                "msg"      : msg,
                                "senderId" : AuthViewModel.getLoggedInUserId(),
                                "timestamp": Date()])
        // Update chat document
        db.collection("chats")
            .document(chat.id!)
            .setData(["updated" : Date(),
                      "lastmsg" : msg],
                     merge: true)
    }
    
    func createChat(chat: Chat, comletion: @escaping (String) -> Void) {
        
        // Get a reference to the Database
        let db = Firestore.firestore()
        
        // Create a document
        let doc = db.collection("chats").document()
        
        // Set data for the document
        try? doc.setData(from: chat, completion: { error in
            // Comunicate the doc id
            comletion(doc.documentID)
        })
        
    }
    
    // MARK: - Close Listeners
    
    func detachChatListViewListeners() {
        for listener in chatListViewListeners {
            listener.remove()
        }
    }
    
    func detachConversationViewListeners() {
        for listener in conversationViewListeners {
            listener.remove()
        }
    }
    
}
