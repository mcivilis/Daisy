//
//  RoundedRectTextOverlay.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-10-07.
//

import SwiftUI

struct RoundedRectText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding(8)
            .background(.black)
            .cornerRadius(20)
            .padding()
    }
}

extension View {
    func roundedRectTextStyle() -> some View {
        modifier(RoundedRectText())
    }
}
