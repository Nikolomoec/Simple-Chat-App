//
//  ContactPickerView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 26.03.2023.
//

import SwiftUI

struct ContactPicker: View {
    
    @Binding var selectedContacts: [User]
    @Binding var isContactPickerShowing: Bool
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ContactPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ContactPicker(selectedContacts: .constant([User]()), isContactPickerShowing: .constant(true))
    }
}
