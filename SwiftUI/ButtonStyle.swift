//
//  ButtonStyle.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-12-21.
//

import SwiftUI

extension ButtonStyle where Self == CapsuleButtonStyle {
    static var capsule: Self {
        return .init()
    }
}

extension ButtonStyle where Self == CountdownButtonStyle {
    static var countdown: Self {
        return .init()
    }
}

struct CapsuleButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .padding(.horizontal, 8)
            .foregroundColor(.black)
            .background(Color.accentColor)
            .clipShape(Capsule())
            .shadow(color: .black, radius: 3)
            .overlay {
                Capsule().stroke(Color.black, lineWidth: 2)
            }
    }
}

struct CountdownButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .padding(.horizontal, 8)
            .foregroundColor(.black)
            .background(Color.accentColor)
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
                .buttonStyle(.countdown)
        }
    }
}
