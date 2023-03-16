//
//  Color+luminance.swift
//  Daisy (iOS)
//
//  Created by Maria Civilis on 2023-03-16.
//

import SwiftUI

extension Color {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0
        guard UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            print("Could not fetch color components for \(self)")
            return (0, 0, 0, 0)
        }

        return (r, g, b, o)
    }

    func contrastRatio(against color: Color) -> Double {
        let luminance1 = self.luminance()
        let luminance2 = color.luminance()

        let luminanceDarker = min(luminance1, luminance2)
        let luminanceLighter = max(luminance1, luminance2)
        return (luminanceLighter + 0.05) / (luminanceDarker + 0.05)
    }

    func luminance() -> Double {
        func adjust(colorComponent: CGFloat) -> CGFloat {
            return (colorComponent < 0.04045) ? (colorComponent / 12.92) : pow((colorComponent + 0.055) / 1.055, 2.4)
        }

        return 0.2126 * adjust(colorComponent: self.components.red) + 0.7152 * adjust(colorComponent: self.components.green) + 0.0722 * adjust(colorComponent: self.components.blue)
    }
}
