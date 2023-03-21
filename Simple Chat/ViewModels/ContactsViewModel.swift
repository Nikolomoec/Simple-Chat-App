//
//  ContactsViewModel.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 20.03.2023.
//

import Foundation
import Contacts

class ContactsViewModel: ObservableObject {
    
    @Published var users = [User]()
    
    private var localContacts = [CNContact]()
    
    func getLocalContacts() {
        
        DispatchQueue.init(label: "getContacts").async {
            let store = CNContactStore()
            
            let keys = [CNContactPhoneNumbersKey,
                        CNContactGivenNameKey,
                        CNContactFamilyNameKey] as [CNKeyDescriptor]
            
            let fetchRequset = CNContactFetchRequest(keysToFetch: keys)
            do {
                try store.enumerateContacts(with: fetchRequset, usingBlock: { contact, succes in
                    self.localContacts.append(contact)
                })
                
                DatabaseService().getPlatformUsers(localContacts: self.localContacts) { platformUsers in
                    DispatchQueue.main.async {
                        self.users = platformUsers
                    }
                }
                
            } catch {
                
            }
        }
    }
}
