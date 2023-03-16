//
//  View+Animation.swift
//  Daisy (iOS)
//
//  Created by Maria Civilis on 2023-03-16.
//

import SwiftUI

// Create an immediate animation.
extension View {
    func animate(using animation: Animation = .linear(duration: 1), _ action: @escaping () -> Void) -> some View {
        onAppear {
            withAnimation(animation) {
                action()
            }
        }
    }
}

// Create an immediate, looping animation
extension View {
    func animateForever(using animation: Animation = .linear(duration: 1), autoreverses: Bool = false, _ action: @escaping () -> Void) -> some View {
        let repeated = animation.repeatForever(autoreverses: autoreverses)

        return onAppear {
            withAnimation(repeated) {
                action()
            }
        }
    }
}
