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
        environment: AppEnvironment()
    )
    
    var body: some Scene {
        WindowGroup {
            DaisyAppView(store: store)
        }
    }
}

/*
 
 Future feature ideas:
 - Refactor to use tabs instead of the segmented control
 
 */
