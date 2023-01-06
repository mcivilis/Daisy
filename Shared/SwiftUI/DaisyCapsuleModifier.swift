//
//  DaisyCapsuleModifier.swift
//  Daisy
//
//  Created by Maria Civilis on 2023-01-06.
//

import SwiftUI

/// Applies capsule formatting to Text view
public extension Text {
    func capsuleStyle() -> some View {
        modifier(DaisyCapsuleModifier())
    }
}

private struct DaisyCapsuleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
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

struct DaisyCapsuleModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Some text")
            .capsuleStyle()
    }
}
