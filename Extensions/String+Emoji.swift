//
//  String+Emoji.swift
//  Daisy (iOS)
//
//  Created by Maria Civilis on 2023-09-21.
//

import Foundation

extension String {

    func containsEmoji() -> Bool {
        
        for character in self {
            var shouldCheckNextScalar = false
            for scalar in character.unicodeScalars {
               if shouldCheckNextScalar {
                    if scalar == "\u{FE0F}" { // scalar that indicates that character should be displayed as emoji
                        return true
                    }
                    shouldCheckNextScalar = false
                }
                
                if scalar.properties.isEmoji {
                    if scalar.properties.isEmojiPresentation {
                        return true
                    }
                    shouldCheckNextScalar = true
                }
            }
        }
        
        return false
    }
}
