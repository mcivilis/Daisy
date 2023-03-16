//
//  Daisy+Preview.swift
//  Daisy (iOS)
//
//  Created by Maria Civilis on 2023-03-13.
//

import ComposableArchitecture
import Foundation
import UIKit

#if DEBUG

extension StoreOf<Daisy> {
    static var preview: Store<Daisy.State, Daisy.Action> = Store(
        initialState: Daisy.State(
            title: "Daisy",
            date: Date(timeIntervalSinceNow: -20),
            imageDescription: "Daisy",
            imageData: UIImage(named: "AppIcon")!.pngData(),
            color: .yellow
        ),
        reducer: Daisy()
    )
}

extension Data {
    static var preview: Data = UIImage(named: "AppIcon")!.pngData()!
}

#endif
