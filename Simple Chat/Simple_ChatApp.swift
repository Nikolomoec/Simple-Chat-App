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
    
    @StateObject var settingsViewModel = SettingsViewModel()
    @StateObject var contactModel = ContactsViewModel()
    @StateObject var chatModel = ChatViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(settingsViewModel.isDarkMode ? .dark : .light)
                .environmentObject(settingsViewModel)
                .environmentObject(contactModel)
                .environmentObject(chatModel)
        }
    }
}
