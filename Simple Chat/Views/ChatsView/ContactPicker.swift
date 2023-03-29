//
//  ContactPickerView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 26.03.2023.
//

import SwiftUI

struct ContactPicker: View {
    
    @Binding var selectedContacts: [User]
    @Binding var isContactPickerShowing: Bool
    
    @EnvironmentObject var contactsModel: ContactsViewModel
    
    var body: some View {
        ZStack {
            // Background Color if needed:
            
            // Contacts
            VStack(spacing: 0) {
                
                // Title
                ZStack {
                    Color("textBubble")
                    Text("Select Contacts to chat with")
                        .foregroundColor(.white)
                        .font(.nameTitle)
                }
                .frame(height: 66)
                
                ScrollView {
                    ForEach(contactsModel.filterUsers) { contact in
                        
                        // Check if user is deactivated
                        if contact.isactive {
                            
                        // Determine if this user is selectedContact
                        var selectedContact = selectedContacts.contains { u in
                            u.id == contact.id
                        }
                            
                            ZStack {
                                ContactRow(user: contact)
                                
                                HStack {
                                    Spacer()
                                    
                                    Button {
                                        // Toogle the contact to be added in selectedContacts
                                        if selectedContact {
                                            
                                            // Find index where we need to remove the contact
                                            let index = selectedContacts.firstIndex(of: contact)
                                            
                                            // Remove this contact from selectedContacts
                                            if let index = index {
                                                selectedContacts.remove(at: index)
                                            }
                                        } else {
                                            // Impose the limit of 3
                                            if selectedContacts.count < 3 {
                                                // Add this contact to selectedContacts
                                                selectedContacts.append(contact)
                                            } else {
                                                // Show message to say limit reached
                                                
                                            }
                                        }
                                        
                                    } label: {
                                        Image(systemName: selectedContact ? "checkmark.circle.fill" : "checkmark.circle")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(Color("textBubble"))
                                    }
                                    
                                }
                            }
                            .padding(.top, 18)
                            .padding(.horizontal, 30)
                            
                        }
                    }
                }
            }
            VStack {
                
                Spacer()
                
                // Done button, dismiss the contact picker
                Button {
                    isContactPickerShowing = false
                } label: {
                    ZStack {
                        Color("textBubble")
                        
                        Text("Done")
                            .font(.nameTitle)
                            .foregroundColor(.white)
                    }
                }
                .frame(height: 56)
            }
        }
        .onAppear {
            contactsModel.filterContacts(filterBy: "")
        }
    }
}


