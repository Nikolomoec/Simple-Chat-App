//
//  DateHelper.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 24.03.2023.
//

import Foundation

class DateHelper {
    
    static func chatTimestampFrom(date: Date?) -> String {
        
        guard date != nil else { return "" }
        
        let msgTime = date!.formatted(date: .omitted, time: .shortened)
        
        return String(msgTime)
    }
    
}
