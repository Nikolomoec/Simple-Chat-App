//
//  TextHelper.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 21.03.2023.
//

import Foundation

class TextHelper {
    
    static func cleanPhoneNumber(_ phone: String) -> String {
        return phone
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")
    }
}
