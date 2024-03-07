//
//  DaisyModel.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-12-21.
//

import Combine
import Foundation
import SwiftUI
import ComposableArchitecture

enum IconType: Codable {
    case symbol
    case text
    case emoji
    case none
}

enum IconShape: Codable, CaseIterable {
    case circleDark
    case circleLight
    case rectangleDark
    case rectangleLight
    case noShapeDark
    case noShapeLight
}

struct Icon: Hashable, Codable {
    var type: IconType
    var shape: IconShape
    var value: String
    
    static var empty: Icon {
        Icon(type: .none, shape: .noShapeDark, value: "")
    }
}

struct Model: Hashable, Codable, Identifiable {
    
    let id: UUID
    var title: String
    var date: Date
    var icon: Icon
    var color: String
    
    init(
        id: UUID = UUID(),
        title: String,
        date: Date,
        icon: Icon,
        color: String
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.icon = icon
        self.color = color
    }
    
    init(_ state: Daisy.State) {
        self.id = state.id
        self.title = state.title
        self.date = state.date
        self.icon = state.icon
        self.color = state.color.toHex() ?? "FFCC00"
    }
}

struct Source {
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    
    private static var fileURL: URL {
        return documentsFolder.appendingPathComponent("daisy.data")
    }
    
    func loadPublisher() -> EffectPublisher<[Model], Never> {
        return EffectPublisher<[Model], Error>.catching {
            let data = try Data(contentsOf: Self.fileURL)
            return try JSONDecoder().decode([Model].self, from: data)
            
        }
        .replaceError(with: [])
        .eraseToEffect()
    }
    
    func savePublisher(_ daisies: IdentifiedArrayOf<Daisy.State>) -> EffectPublisher<Void, Error> {
        let models = daisies.map { Model($0) }
        
        return EffectPublisher<Void, Error>.catching {
            let data = try JSONEncoder().encode(models)
            return try data.write(to: Self.fileURL)
        }
        .eraseToEffect()
    }
}
