//
//  DaisyCapsuleModifier.swift
//  Daisy
//
//  Created by Maria Civilis on 2023-01-06.
//

import SwiftUI

/// Applies capsule formatting to Text view
public extension Text {
    func capsuleStyle(color: Color) -> some View {
        modifier(DaisyCapsuleModifier(color: color))
    }
}

private struct DaisyCapsuleModifier: ViewModifier {
    
    let color: Color

    func body(content: Content) -> some View {
        content
            .padding(8)
            .padding(.horizontal, 8)
            .background(color)
            .foregroundColor(.black)
            .clipShape(Capsule())
            .shadow(color: .black, radius: 3)
            .overlay {
                Capsule().stroke(Color.black, lineWidth: 2)
            }
    }
}

struct DaisyCapsuleModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Some text")
            .capsuleStyle(color: .yellow)
    }
}
