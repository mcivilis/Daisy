//
//  DaisyShape.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-12-15.
//

import SwiftUI

struct DaisyShape: View {
    var body: some View {
        ForEach(0..<8) { index in
                 RotatedPetalView(
                     angle: .degrees(Double(index) / Double(8)) * 360.0
                 )
             }
    }
}

struct DaisyShape_Previews: PreviewProvider {
    static var previews: some View {
        DaisyShape()
    }
}
