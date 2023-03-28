//
//  ContactsListView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 21.03.2023.
//

import SwiftUI

struct ContactsListView: View {
    
    @State private var search = ""
    
    @Binding var isChatShowing: Bool
    @Binding var isSettingsShowing: Bool
    
    @EnvironmentObject var contactsModel: ContactsViewModel
    @EnvironmentObject var chatModel: ChatViewModel
    
    var body: some View {
        VStack {
            // Heading
            HStack(spacing: 180) {
                Text("Contacts")
                    .font(.chat_contactsTitle)
                
                Button {
                    // Open Settings
                    isSettingsShowing = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .tint(.black)
                        .scaledToFill()
                        .frame(width: 26, height: 26)
                }
                
            }
            .padding(.top, 16)
            
            // SearchBar
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .foregroundColor(Color("searchBar"))
                    .frame(height: 45)
                TextField("Search a Contact", text: $search)
                    .foregroundColor(Color("searchBarText"))
                    .padding(10)
                    .padding(.leading)
            }
            .padding(.horizontal, 35)
            .onChange(of: search) { _ in
                contactsModel.filterContacts(filterBy: search.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
            }
            
            if contactsModel.filterUsers.count > 0 {
                // List
                List(contactsModel.filterUsers) { user in
                    Button {
                        // Search an existing convo with this user
                        chatModel.getChatFor(contacts: [user])
                        
                        // Display ConverstionView
                        isChatShowing = true
                        
                    } label: {
                        ContactRow(user: user)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .buttonStyle(.plain)
                }
                .listStyle(.plain)
                .padding(.horizontal, 10)
            } else {
                
                Spacer()
                
                VStack {
                    
                    Image("noContacts")
                        .resizable()
                        .frame(width: 200, height: 176)
                        .padding(.bottom, 29)
                    
                    VStack {
                        Text("Hmm... no contacts yet  :(")
                            .font(.noChats_noContactsTitle)
                            .padding(.bottom, 2)
                        Text("Add a contact to start chatting")
                            .font(.noChats_noContactsDesc)
                    }
                    .foregroundColor(Color("secondaryText"))
                    .multilineTextAlignment(.center)
                }
                .padding()
                .padding(.bottom, 90)
                
                
                Spacer()
                
            }
        }
    }
}

struct ContactsListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsListView(isChatShowing: .constant(true), isSettingsShowing: .constant(false))
            .environmentObject(ContactsViewModel())
            .environmentObject(ChatViewModel())
    }
}
