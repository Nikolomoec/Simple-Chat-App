//
//  DatabaseService.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 21.03.2023.
//

import Foundation
import Contacts
import Firebase

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
    
}
