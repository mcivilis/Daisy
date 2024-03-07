//
//  DaisySpinner.swift
//  Daisy (iOS)
//
//  Created by Maria Civilis on 2023-03-16.
//

import SwiftUI

struct DaisySpinner: View {
    
    @State var degrees: Double = 0
    
    var body: some View {
        VStack {
            Text("Generating...")
                .font(.title3)
                .padding()
            DaisyIcon(petals: 18, usesShadow: false, strokeWidth: 2)
                .frame(width: 125, height: 125)
                .rotationEffect(.degrees(degrees))
                .animateForever(autoreverses: false) { degrees = 180 }
        }
    }
}

struct DaisySpinner_Previews: PreviewProvider {
    static var previews: some View {
        DaisySpinner()
    }
}
