//
//  DaisyView.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-10-15.
//

import SwiftUI
import ComposableArchitecture

struct EditDaisy: ReducerProtocol {
    
    struct State: Equatable {

        let id: UUID
        var title: String
        var date: Date
        var symbolName: String?
        var color: Color
        
        var editMode: EditMode = .inactive
        
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
    
    enum Action: Equatable {
        case save
        case cancel
        case textFieldChanged(String)
        case editModeChanged(EditMode)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .save:
            break
        case .cancel:
            break
        case .textFieldChanged:
            break
        case let .editModeChanged(editMode):
            state.editMode = editMode
            return .none
            
        }
        return .none
    }
}

struct EditView: View {
    
    let store: StoreOf<Daisy>
    
    init(store: StoreOf<Daisy>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text(viewStore.title)
//                TextField(
//                    viewStore.title,
//                    text: viewStore.binding(get: \.title, send: EditDaisy.Action.textFieldChanged)
//                )
            }
        }
        
    }
}
