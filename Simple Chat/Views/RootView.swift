//
//  ContentView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 18.03.2023.
//

import SwiftUI

struct RootView: View {
    
    @State var selectedTab: Tabs = .chats
    
    var body: some View {
        VStack {
            
            Text("Hello, world!")
            
            Spacer()
            
            CustomTapBar(selectedTab: $selectedTab)
            
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
