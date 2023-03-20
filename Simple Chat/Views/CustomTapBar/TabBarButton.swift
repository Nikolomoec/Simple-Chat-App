//
//  TabBarButton.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 20.03.2023.
//

import SwiftUI

struct TabBarButton: View {
    
    var image: String
    var name: String
    var isActive: Bool
    
    var body: some View {
        GeometryReader { geo in
            
            if isActive {
                Rectangle()
                    .foregroundColor(Color("textBubble"))
                    .frame(width: geo.size.width/2, height: 4)
                    .padding(.leading, geo.size.width/4)
            }
            VStack(alignment: .center, spacing: 4) {
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                Text(name)
                    .font(Font.tapBar)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .foregroundColor(Color("secondaryText"))
        }
    }
}

struct TabBarButton_Previews: PreviewProvider {
    static var previews: some View {
        TabBarButton(image: "person", name: "Contacts", isActive: true)
    }
}
