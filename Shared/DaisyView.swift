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
    var symbolName: String?
    var color: Color
    
    var isPast: Bool {
        return date >= Date.now
    }
    
    init(
        title: String = "",
        date: Date = .now,
        symbolName: String? = nil,
        color: Color = Color.accentColor
    ) {
        self.id = UUID()
        self.title = title
        self.date = date
        self.symbolName = symbolName
        self.color = color
    }
}

// MARK: Action

enum DaisyAction: Equatable {
  case showDetail
  case delete
}

// MARK: Environment

struct DaisyEnvironment {}

// MARK: Environment

let daisyReducer = Reducer<DaisyState, DaisyAction, DaisyEnvironment> { state, action, _ in
    switch action {
    case .showDetail:
        break
    case .delete:
        break
    }
    return .none
}

// MARK: View

struct DaisyView: View {
    let store: Store<DaisyState, DaisyAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(.accentColor)
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(viewStore.title)
                            .font(.title2)
                            .foregroundColor(.black)
                        Text(viewStore.date.daisy())
                            .foregroundColor(.white)
                            .padding(8)
                            .background(.black)
                            .cornerRadius(20)
                        Text(viewStore.date.display())
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                    .opacity(0.7)
                    .padding()
                    Spacer()
                    if let symbolName = viewStore.symbolName {
                        Image(systemName: symbolName)
                            .resizable()
                            .frame(width: 125, height: 125)
                            .foregroundColor(.black)
                            .padding()
                            .opacity(0.7)
                    }
                }.padding()
            }
        }
    }
}


struct DaisyView_Previews: PreviewProvider {
    static var store: Store<DaisyState, DaisyAction> = Store(
        initialState: DaisyState(
            title: "Amelia's Birthday",
            date: Date.preview("2:32 Wed, 22 Sep 2019"),
            symbolName: "birthday.cake.fill"
        ),
        reducer: daisyReducer,
        environment: DaisyEnvironment()
    )
    
    static var previews: some View {
        VStack {
            Spacer()
                .frame(maxHeight: .infinity)
            DaisyView(store: store)
            Spacer()
                .frame(maxHeight: .infinity)
        }
    }
}
