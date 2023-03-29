//
//  SettingsViewModel.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 29.03.2023.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    
    @AppStorage(Constans.darkModeKey) var isDarkMode = false
    
    private let databaseService = DatabaseService()
    
    // Deactivating user account
    func deactivateUser(completion: @escaping () -> Void) {
        databaseService.deactivateAccount {
            
            // Deactivation is complete
            completion()
            
        }
    }
}
