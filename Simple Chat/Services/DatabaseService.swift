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
import UIKit

class DatabaseService {
    
    func getPlatformUsers(localContacts: [CNContact], completion: @escaping([User]) -> Void) {
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
            let query = db.collection("users").whereField("phone", in: tenPhoneNumbers)
            
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
                    
                    // Set the image data to profile
                    
                    // We are using "merge: true" bc we want it
                    // to update the user profile not to override it
                    
                    doc.setData(["photo": path], merge: true) { error in
                        if error == nil {
                            // Sucsess, notify user
                            completion(true)
                        }
                    }
                    
                } else {
                    completion(false)
                }
            }
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
}
