//
//  GroupProfileImageView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 27.03.2023.
//

import SwiftUI

struct GroupProfileImageView: View {
    
    var users: [User]
    
    var body: some View {
        
        let offsetNum = Int(30 / users.count) * -1
        
        ZStack {
            ForEach(Array(users.enumerated()), id: \.element) { index, user in
                ProfileImageView(user: user)
                    .offset(x: CGFloat(offsetNum * index))
            }
        }
        .offset(x: CGFloat((users.count - 1) * abs(offsetNum) / 2))
        
    }
}

struct GroupProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        GroupProfileImageView(users: [User]())
    }
}
