//
//  DaisyButton.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-12-21.
//

import SwiftUI

extension ButtonStyle where Self == CapsuleButtonStyle {
    static func capsule(_ color: Color) -> Self {
        return .init(color: color)
    }
}

extension ButtonStyle where Self == DaisyButtonStyle {
    static var daisy: Self {
        return .init()
    }
}

struct CapsuleButtonStyle: ButtonStyle {
    
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .padding(.horizontal, 8)
            .foregroundColor(color.luminance() > 0.1 ? .black : .white)
            .background(color)
            .clipShape(Capsule())
            .shadow(color: .black, radius: 3)
            .overlay {
                Capsule().stroke(Color.black, lineWidth: 2)
            }
    }
}

struct DaisyButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .padding(.horizontal, 8)
            .foregroundColor(.black)
            .background(.yellow)
            .clipShape(Capsule())
            .shadow(color: .black, radius: 3)
            .overlay {
                Capsule().stroke(Color.black, lineWidth: 2)
            }
    }
}

struct DaisyButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button("Press Me") {}
                .buttonStyle(.daisy)
        }
    }
}
