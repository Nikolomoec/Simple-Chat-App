//
//  UserModel.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 21.03.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable {
    
    @DocumentID var id: String?
    var firtstName: String?
    var lastName: String?
    var phone: String?
    var photo: String?
    
}
