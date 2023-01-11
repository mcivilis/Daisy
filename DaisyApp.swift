//
//  DaisyApp.swift
//  Shared
//
//  Created by Maria Civilis on 2022-07-15.
//

import ComposableArchitecture
import SwiftUI

@main
struct DaisyApp: App {
     
    var body: some Scene {
        WindowGroup {
            ListView(
                store: Store(
                    initialState: DaisyList.State(),
                    reducer: DaisyList(daisySource: Source())
                )
            )
        }
    }
}
