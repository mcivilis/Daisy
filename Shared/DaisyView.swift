//
//  DaisyView.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-10-15.
//

import SwiftUI
import ComposableArchitecture

// MC: - ListItem should really be Daisy instead
struct Daisy: ReducerProtocol {
    
    struct State: Equatable {
        let id: UUID
        var title: String
        var date: Date
        var symbolName: String?
        var color: Color
        
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
        //case editModeChanged(EditMode)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .save:
            break
        case .cancel:
            break
//        case let .editModeChanged(editMode):
//            state.editMode = editMode
//            return .none
        }
        return .none
    }
}

struct DaisyView: View {
    
    let store: StoreOf<ListItem>
    //@ObservedObject var viewStore: ViewStore<ViewState, Daisy.Action>
    
    init(store: StoreOf<ListItem>) {
        self.store = store
        //self.viewStore = ViewStore(self.store.scope(state: ViewState())
    }
    
    struct ViewState: Equatable {
        //let editMode: EditMode = .inactive
    }
    
    var body: some View {
        Form {
            Text("Hello")
            //TextField("Title", text: daisyState.title)
        }
        //.navigationTitle(store.state.title)
//        .navigationBarItems(
//            leading: HStack {
//                EditButton()
//                Button("Delete") {
//                    //viewStore.send(.delete)
//                }
//            },
//            trailing: Button("Reset to Now") {
//                //viewStore.send(.reset)
//            }
//        )
//        .environment(
//            \.editMode,
//             viewStore.binding(get: \.editMode, send: DaisyList.Action.editModeChanged)
//        )
    }
}

//struct DaisyView_Previews: PreviewProvider {
//    static var previews: some View {
//        DaisyView()
//    }
//}
