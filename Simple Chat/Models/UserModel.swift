//
//  UserModel.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 21.03.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable, Hashable {
    
    @DocumentID var id: String?
    var firstName: String?
    var lastName: String?
    var phone: String?
    var photo: String?
    
}
