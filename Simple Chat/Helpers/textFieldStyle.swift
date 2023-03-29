//
//  textFieldStyle.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 20.03.2023.
//

import Foundation
import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("searchBar"))
                .frame(height: 46)
            configuration
                .font(.verificationDesc_numberPlaceHolder)
                .padding()
        }
        .padding(.horizontal)
    }
    
}
