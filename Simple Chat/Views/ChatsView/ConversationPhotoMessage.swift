//
//  ConversationPhotoMessage.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 26.03.2023.
//

import SwiftUI

struct ConversationPhotoMessage: View {
    
    var imageUrl: String
    var isFromUser: Bool
    
    var body: some View {
        if let cachedImage = CacheService.getImage(forKey: imageUrl) {
            
            // Image is in cache, so lets use it
            cachedImage
                .resizable()
                .scaledToFill()
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .background(isFromUser ? Color("textBubble") : Color("searchBar"))
                .cornerRadius(30, corners: isFromUser ? [.bottomLeft,.topLeft,.topRight] : [.bottomRight,.topLeft,.topRight])
        } else {
            // Create url from msg image url
            let photoUrl = URL(string: imageUrl)
            
            AsyncImage(url: photoUrl) { phase in
                switch phase {
                    
                case .empty:
                    // Progress View bc it is fetching
                    ProgressView()
                    
                case .success(let image):
                    
                    image
                        .resizable()
                        .scaledToFill()
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(isFromUser ? Color("textBubble") : Color("searchBar"))
                        .cornerRadius(30, corners: isFromUser ? [.bottomLeft,.topLeft,.topRight] : [.bottomRight,.topLeft,.topRight])
                        .onAppear {
                            // Save this image to cache
                            CacheService.setImage(image: image, forKey: imageUrl)
                        }
                case .failure:
                    ConversationTextMesage(msg: "Failed to load the image", isFromUser: isFromUser)
                }
            }
        }
    }
}

struct ConversationPhotoMessage_Previews: PreviewProvider {
    static var previews: some View {
        ConversationPhotoMessage(imageUrl: "url", isFromUser: true)
    }
}
