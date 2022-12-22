//
//  DaisyButton.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-12-21.
//

import SwiftUI

struct DaisyButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .padding(.horizontal, 8)
            .background(Color.Button.background)
            .foregroundColor(Color.Button.foreground)
            .clipShape(Capsule())
            .shadow(color: .black, radius: 3)
            .overlay {
                Capsule().stroke(Color.Button.stroke, lineWidth: 2)
            }
    }
}

struct DaisyButtonStyle_Previews: PreviewProvider {
    static var previews: some View {        
        Button("Press Me") {
            print("Button pressed!")
        }
        .buttonStyle(DaisyButtonStyle())
    }
}
