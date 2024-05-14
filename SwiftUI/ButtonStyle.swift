//
//  ButtonStyle.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-12-21.
//

import SwiftUI

extension ButtonStyle where Self == CapsuleButtonStyle {
    static func capsule(_ theme: Theme) -> Self {
        return .init(dark: theme.dark, light: theme.light)
    }
}

extension ButtonStyle where Self == CountdownButtonStyle {
    static func countdown(_ theme: Theme) -> Self {
        return .init(dark: theme.dark, light: theme.light)
    }
}

struct CapsuleButtonStyle: ButtonStyle {
    
    let dark: Color
    let light: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .padding(.horizontal, 8)
            .foregroundColor(dark)
            .background(light)
            .clipShape(Capsule())
            .shadow(color: .black, radius: 3)
            .overlay {
                Capsule().stroke(Color.black, lineWidth: 2)
            }
    }
}

struct CountdownButtonStyle: ButtonStyle {
    
    let dark: Color
    let light: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .padding(.horizontal, 8)
            .foregroundColor(dark)
            .background(light)
            .clipShape(Capsule())
            .shadow(color: .black, radius: 3)
            .overlay {
                Capsule().stroke(Color.black, lineWidth: 2)
            }
    }
}

struct CountdownButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button("Press Me") {}
                .buttonStyle(.countdown(.bright))
        }
    }
}
