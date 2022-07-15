//
//  Daisy.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-07-15.
//

import Foundation

struct Daisy: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let date: Date
}

extension Daisy {
    static var preview: Daisy {
        Daisy(title: "Daisy", date: Date())
    }
    
    static var previewMany: [Daisy] {
        [Daisy(title: "Daisy 1", date: Date()),
         Daisy(title: "Daisy 2", date: Date(timeIntervalSinceNow: 3600)),
         Daisy(title: "Daisy 3", date: Date(timeIntervalSinceNow: 36000)),
         Daisy(title: "Daisy 4", date: Date(timeIntervalSinceNow: 360000))]
    }
}
