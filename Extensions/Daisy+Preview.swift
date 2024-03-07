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
            title: "Vacation",
            date: Date(timeIntervalSinceNow: -20),
            icon: .preview,
            color: .yellow
        ),
        reducer: Daisy()
    )
}

extension Icon {
    static var preview: Icon {
        Icon(type: .symbol, shape: .noShapeDark, value: "birthday.cake")
    }
}

#endif
