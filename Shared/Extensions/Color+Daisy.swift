//
//  Color+Daisy.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-12-21.
//

import SwiftUI

extension Color {
    struct Button {
        static var background: Color {
            Color("ButtonBackground")
        }
        
        static var foreground: Color {
            Color("ButtonForeground")
        }
        
        static var stroke: Color {
            Color("ButtonStroke")
        }
    }
    
    static var header: Color {
        Color("Header")
    }
    
    static var background: Color {
        Color("Background")
    }
    
    static var foreground: Color {
        Color("Foreground")
    }
    
    static var stroke: Color {
        Color("Stroke")
    }
}
