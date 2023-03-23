//
//  ConversationView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 22.03.2023.
//

import SwiftUI

struct ConversationView: View {
    
    @Binding var isChatShowing: Bool
    
    @State private var message = ""
    
    var body: some View {
        VStack {
            // Header
            ZStack {
                Color("backgroundScreen")
                    .ignoresSafeArea()
                    .frame(height: 109)
                HStack {
                    VStack(alignment: .leading) {
                        
                        Button {
                            isChatShowing.toggle()
                        } label: {
                            Image(systemName: "arrow.backward")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                                .padding(.leading, 10)
                        }
                        
                        Text("Nikita Kolomoiets")
                            .font(.nameTitle)
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                    
                    ProfileImageView(user: User())
                }
                .padding(.trailing, 36)
                .padding(.leading, 16)
            }
            // Chat
            ScrollView {
                VStack(spacing: 24) {
                    // Their message
                    HStack {
                        
                        Text("Lorem ipsum dolor sit amet consectetur. Parturient egestas vel...")
                            .font(.message)
                            .foregroundColor(.black)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                            .background(Color("searchBar"))
                            .cornerRadius(30, corners: [.bottomRight,.topLeft,.topRight])
                        
                        Spacer()
                        
                        Text("9:41")
                            .font(.chatDate_Time)
                            .padding(.leading)
                    }
                    .padding(.horizontal)
                    
                    // Your message
                    HStack {
                        
                        Text("9:41")
                            .font(.chatDate_Time)
                            .padding(.trailing)
                        
                        Spacer()
                        
                        Text("Lorem ipsum dolor sit amet consectetur. Parturient egestas velhgjg hgjgjhj jhjgjgjg...")
                            .font(.message)
                            .foregroundColor(.white)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                            .background(Color("textBubble"))
                            .cornerRadius(30, corners: [.bottomLeft,.topLeft,.topRight])

                    }
                    .padding(.horizontal)
                    
                }
                .padding(.top)
            }
            // Message bar
            ZStack {
                Color.white
                    .ignoresSafeArea()
                    .frame(height: 85)
                HStack() {
                    
                    // Picker Photo Button
                    Button {
                        
                    } label: {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 33, height: 33)
                            .foregroundColor(Color("secondaryText"))
                    }
                    
                    // TextField
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 270, height: 44)
                            .foregroundColor(Color("searchBar"))
                        TextField("Aa", text: $message)
                            .padding(10)
                            .padding(.leading, 7)
                            .font(.chatTextField)
                        HStack {
                            Spacer()
                            
                            Button {
                                // Emoji picker
                                
                            } label: {
                                Image(systemName: "face.smiling")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(Color("systemIcons"))
                            }
                            .padding(.trailing, 12)
                        }

                    }
                    .padding(.horizontal, 13.5)
                    
                    // Send Button
                    Button {
                        
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 33, height: 33)
                            .foregroundColor(Color("textBubble"))
                    }

                }
                .padding(.horizontal, 30)
            }
        }
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView(isChatShowing: .constant(true))
    }
}
