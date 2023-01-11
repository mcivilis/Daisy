//
//  DaisyButton.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-12-21.
//

import SwiftUI

struct DaisyButtonStyle: ButtonStyle {
    
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .padding(.horizontal, 8)
            .foregroundColor(.black)
            .background(color)
            .clipShape(Capsule())
            .shadow(color: .black, radius: 3)
            .overlay {
                Capsule().stroke(Color.black, lineWidth: 2)
            }
    }
}

struct DaisyButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Press Me") {}
            .buttonStyle(DaisyButtonStyle(color: .yellow ))
    }
}
