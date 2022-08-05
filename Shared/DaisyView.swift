//
//  DaisyView.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-07-29.
//

import SwiftUI
import ComposableArchitecture

// MARK: State

struct DaisyState: Equatable, Identifiable {
    let id: UUID
    var title: String
    var date: Date
    var isComplete: Bool = false // TODO MC: remove
    var isPast: Bool {
        return date >= Date.now
    }
    
    init(id: UUID = UUID(), title: String = "", date: Date = .now) {
        self.id = id
        self.title = title
        self.date = date
    }
}

// MARK: Action

enum DaisyAction: Equatable {
    // TODO MC: remove action
  case checkBoxToggled
  case textFieldChanged(String)
}

// MARK: Environment

struct DaisyEnvironment {}

// MARK: Environment

let daisyReducer = Reducer<DaisyState, DaisyAction, DaisyEnvironment> { state, action, _ in
  switch action {
  case .checkBoxToggled:
      state.isComplete.toggle()
  case let .textFieldChanged(title):
    state.title = title
  }
    return .none
}

// MARK: View

struct DaisyView: View {
  let store: Store<DaisyState, DaisyAction>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      HStack {
        Button(action: { viewStore.send(.checkBoxToggled) }) {
          Image(systemName: viewStore.isComplete ? "checkmark.square" : "square")
        }
        .buttonStyle(.plain)

        TextField(
          "Untitled Daisy",
          text: viewStore.binding(get: \.title, send: DaisyAction.textFieldChanged)
        )
      }
      .foregroundColor(viewStore.isComplete ? .gray : nil)
    }
  }
}
