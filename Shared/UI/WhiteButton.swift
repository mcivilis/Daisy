//
//  WhiteButton.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-12-11.
//

import SwiftUI

struct WhiteButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(.white)
            .foregroundColor(.black)
            .clipShape(Capsule())
            .shadow(radius: 2)
    }
}

struct ButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Press Me") {
            print("Button pressed!")
        }
        .buttonStyle(WhiteButton())
    }
}
