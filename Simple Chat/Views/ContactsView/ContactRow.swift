//
//  ContactRow.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 22.03.2023.
//

import SwiftUI

struct ContactRow: View {
    
    var user: User
    
    var body: some View {
        
        HStack(spacing: 24) {
            // Profile Image
            ProfileImageView(user: user)
            
            VStack(alignment: .leading, spacing: 4) {
                // Name
                Text("\(user.firstName ?? "") \(user.lastName ?? "")")
                    .font(.namePreview)
                // PhoneNumber
                Text(user.phone ?? "")
                    .font(.message)
                    .foregroundColor(Color("searchBarText"))
            }
            
            Spacer()
            
        }
            
    }
}

struct ContactRow_Previews: PreviewProvider {
    static var previews: some View {
        ContactRow(user: User())
    }
}
