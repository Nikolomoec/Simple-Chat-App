//
//  ButtonStyle.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 20.03.2023.
//

import Foundation
import SwiftUI

struct StartButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .frame(width: 340, height: 55)
                .foregroundColor(Color("primaryButton"))
            configuration.label
                .foregroundColor(Color("backgroundScreen"))
                .font(.startButton)
        }
    }
}
