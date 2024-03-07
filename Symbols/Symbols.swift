//
//  Symbols.swift
//  Daisy (iOS)
//
//  Created by Maria Civilis on 2023-09-20.
//

import Foundation

struct Symbols {
    static let all: [String] = {
        let path = Bundle.main.path(forResource: "sfsymbols", ofType: "txt")
        if let path, let content = try? String(contentsOfFile: path) {
            return content
                .split(separator: "\n")
                .map { String($0) }
        } else {
            return []
        }
    }()
}
