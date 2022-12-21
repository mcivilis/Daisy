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
      DaisyListView(
        store: Store(
            initialState: DaisyList.State(daisies: .testData),
          reducer: DaisyList()
        )
      )
    }
  }
}

// MARK: Test date
extension IdentifiedArray where ID == ListItem.State.ID, Element == ListItem.State {
    static let testData: Self = [
        ListItem.State(title: "Birthday", date: Date.preview("0:00 Mon, 30 Nov 1987"), symbolName: "birthday.cake.fill"),
        ListItem.State(title: "Exercise", date: Date.preview("0:00 Tue, 1 Dec 2022"), symbolName: "figure.indoor.cycle"),
        ListItem.State(title: "Vacation", date: Date.preview("0:00 Sun, 19 Feb 2023"), symbolName: "beach.umbrella.fill")
    ]
}

/*
 
 Future feature ideas:
 - Refactor to use tabs instead of the segmented control
 - Navigation link -> Sheet presentation
 
 */
