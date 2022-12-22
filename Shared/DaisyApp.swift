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

/*
 
 Future feature ideas:
 - Refactor to use tabs instead of the segmented control
 - Navigation link -> Sheet presentation
 - Implement theme with accentColor background and a dark mode gray background instead of black
 
 */
