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

struct Model: Hashable, Codable, Identifiable {

    let id: UUID
    var title: String
    var date: Date
    var symbolName: String
    var color: String
    
    init(
        id: UUID = UUID(),
        title: String,
        date: Date,
        symbolName: String = "",
        color: String
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.symbolName = symbolName
        self.color = color
    }
    
    init(_ state: Daisy.State) {
        self.id = state.id
        self.title = state.title
        self.date = state.date
        self.symbolName = state.symbolName
        self.color = state.color.toHex() ?? "FFCC00"
    }
}

// TODO makes this a struct?
final class Source {
    
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
//    func load() {
//        DispatchQueue.global(qos: .background).async { [weak self] in
//            guard let data = try? Data(contentsOf: Self.fileURL) else {
//                #if DEBUG
//                DispatchQueue.main.async {
//                    self?.models = []
//                }
//                #endif
//                return
//            }
//            guard let models = try? JSONDecoder().decode([Daisy].self, from: data) else {
//                fatalError("Can't decode saved session data.")
//            }
//            DispatchQueue.main.async {
//                self?.models = models
//            }
//        }
//    }
//
//    func save() {
//        DispatchQueue.global(qos: .background).async { [weak self] in
//            guard let models = self?.models else { fatalError("Self out of scope") }
//            guard let data = try? JSONEncoder().encode(models) else { fatalError("Error encoding data") }
//            do {
//                let outfile = Self.fileURL
//                try data.write(to: outfile)
//            } catch {
//                fatalError("Can't write to file")
//            }
//        }
//    }
}
                                            
//extension Source {
//    static var mock: Source {
//        let source = Source()
//        source.models = [
//            Daisy(title: "Birthday", date: Date.preview("0:00 Mon, 30 Nov 1987"), symbolName: "birthday.cake.fill"),
//            Daisy(title: "Exercise", date: Date.preview("0:00 Tue, 1 Dec 2022"), symbolName: "figure.indoor.cycle"),
//            Daisy(title: "Vacation", date: Date.preview("0:00 Sun, 19 Feb 2023"), symbolName: "beach.umbrella.fill")
//        ]
//        return source
//    }
//}

extension Source {
    static var random: Daisy.State {
        let model = sampleData.randomElement()!
        return Daisy.State(
            title: model.title,
            date: model.date,
            symbolName: model.symbolName,
            color: .accentColor
        )
    }
    
    static var sampleData: [Model] {
        [
            Model(title: "Birthday", date: Date.preview("0:00 Mon, 30 Nov 1987"), symbolName: "birthday.cake.fill", color: "FFCC00"),
            Model(title: "Exercise", date: Date.preview("0:00 Tue, 1 Dec 2022"), symbolName: "figure.indoor.cycle", color: "FFCC00"),
            Model(title: "Vacation", date: Date.preview("0:00 Sun, 19 Feb 2023"), symbolName: "beach.umbrella.fill", color: "FFCC00")
        ]
    }
}
