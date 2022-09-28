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
    
    let store = Store(
        initialState: AppState(),
        reducer: daisyAppReducer,
        environment: AppEnvironment(mainQueue: .main, uuid: { UUID() })
    )
    
    var body: some Scene {
        WindowGroup {
            DaisiesView(store: store)
        }
    }
}

/*
 
 Future feature ideas:
 - Refactor to use tabs instead of the segmented control
 
 */
