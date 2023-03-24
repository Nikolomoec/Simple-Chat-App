//
//  ContactsViewModel.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 20.03.2023.
//

import Foundation
import Contacts

class ContactsViewModel: ObservableObject {
    
    private var users = [User]()
    
    private var filterText = ""
    
    @Published var filterUsers = [User]()
    
    private var localContacts = [CNContact]()
    
    func getLocalContacts() {
        
        DispatchQueue.init(label: "getcontacts").async {
            do {
            let store = CNContactStore()
            
            let keys = [CNContactGivenNameKey,
                        CNContactFamilyNameKey,
                        CNContactPhoneNumbersKey] as [CNKeyDescriptor]
            
            let fetchRequset = CNContactFetchRequest(keysToFetch: keys)
                try store.enumerateContacts(with: fetchRequset, usingBlock: { contact, success in
                    self.localContacts.append(contact)
                })
                
                // See which local contacts are actually users of this app
                DatabaseService().getPlatformUsers(localContacts: self.localContacts) { platformUsers in
                    DispatchQueue.main.async {
                        self.users = platformUsers
                        
                        // Set the filtered list of users
                        self.filterContacts(filterBy: self.filterText)
                    }
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func filterContacts(filterBy: String) {
        
        self.filterText = filterBy
        
        if filterText == "" {
            self.filterUsers = users
            return
        } else {
            self.filterUsers = users.filter({ user in
                user.firstName?.lowercased().contains(filterText) ?? false || user.lastName?.lowercased().contains(filterText) ?? false || user.phone?.contains(filterText) ?? false
            })
        }
    }
    
    func getParticipants(ids: [String]) -> [User] {
        
        // Filter out the userId for only the participants base ob ids passed in
        let foundUsers = users.filter { user in
            if user.id == nil {
                return false
            } else {
                return ids.contains(user.id!)
            }
        }
        return foundUsers
    }
}
