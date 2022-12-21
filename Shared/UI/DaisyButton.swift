//
//  DaisyButton.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-12-21.
//

import SwiftUI

struct DaisyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(12)
            .background(Color.accentColor)
            .foregroundColor(.black)
            .clipShape(Capsule())
            .shadow(color: Color.black, radius: 3)
            .overlay {
                Capsule().stroke(Color.black, lineWidth: 2)
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
