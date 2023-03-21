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
    static func limitText(_ stringvar: inout String, _ limit: Int) {
        if stringvar.count > limit {
            stringvar = String(stringvar.prefix(limit))
        }
    }
    static func applyPatternOnNumbers(_ stringvar: inout String, pattern: String, replacementCharacter: Character) {
        var pureNumber = stringvar.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else {
                stringvar = pureNumber
                return
            }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        stringvar = pureNumber
        
        if stringvar.count > 18 {
            stringvar = String(stringvar.prefix(18))
        }
    }
}
