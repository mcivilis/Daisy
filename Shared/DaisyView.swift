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
            VStack {
                RoundedRectangle(cornerRadius: 60)
                    .foregroundColor(viewStore.color)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        VStack {
                            Text(viewStore.date.daisy())
                                .font(.title2)
                                .roundedRectTextStyle()
                            if let symbolName = viewStore.symbolName {
                                VStack {
                                    Spacer()
                                    Image(systemName: symbolName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.black)
                                        .padding(10)
                                }
                            } else {
                                
                            }
                            Text(viewStore.date.display())
                                .bold()
                                .padding()
                                .foregroundColor(.black)
                        }
                        .opacity(0.7)
                    }
                Text(viewStore.title)
            }
            .padding()
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
            DaisyView(store: store)
                .previewLayout(.fixed(width: 300, height: 300))
    }
}
