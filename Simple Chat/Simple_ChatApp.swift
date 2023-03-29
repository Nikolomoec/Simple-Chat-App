//
//  Simple_ChatApp.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 18.03.2023.
//

import SwiftUI

@main
struct Simple_ChatApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
            //    .preferredColorScheme(.dark)
                .environmentObject(ContactsViewModel())
                .environmentObject(ChatViewModel())
        }
    }
}
