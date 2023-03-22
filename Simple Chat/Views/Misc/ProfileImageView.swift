//
//  ProfileImageView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 22.03.2023.
//

import SwiftUI

struct ProfileImageView: View {
    
    var user: User
    
    var body: some View {
        ZStack {
            
            // Check if user has a photo
            
            if user.photo == nil {
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                    Text(user.firstName?.prefix(1) ?? "")
                        .bold()
                }
            } else {
                // Create url from user photo url
                let photoUrl = URL(string: user.photo ?? "")
                
                AsyncImage(url: photoUrl) { phase in
                    switch phase {
                    case .empty:
                        // Progress View bc it fetching
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                            Text(user.firstName?.prefix(1) ?? "")
                                .bold()
                        }
                    }
                }
            }
            
            Circle()
                .stroke(Color("profileBorder"), lineWidth: 2)
        }
        .frame(width: 48, height: 48)
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView(user: User())
    }
}
