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
                // Check image cache, if it's exists, use that:
                if let cachedImage = CacheService.getImage(forKey: user.photo!) {
                    // Image is in cache, so lets use it
                    cachedImage
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                } else {
                    // If not in cache do this:
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
                                .onAppear {
                                    // Save this image into cache
                                    CacheService.setImage(image: image, forKey: user.photo!)
                                }
                        case .failure:
                            ZStack {
                                Circle()
                                    .foregroundColor(.white)
                                Text(user.firstName?.prefix(1) ?? "")
                                    .bold()
                            }
                        }
                    }
                    .clipShape(Circle())
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
