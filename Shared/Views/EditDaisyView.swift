//
//  DaisyView.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-10-15.
//

import SwiftUI
import ComposableArchitecture
import SymbolPicker

struct EditDaisy: ReducerProtocol {
    
    struct State: Equatable, Identifiable {
        let id: UUID
        @BindableState var title: String
        @BindableState var date: Date
        var symbolName: String
        var symbolPickerPresented: Bool
        @BindableState var color: Color
        
        var editMode: EditMode = .inactive
        
        init(
            title: String = "",
            date: Date = .now,
            symbolName: String = "",
            symbolPickerPresented: Bool = false,
            color: Color = Color.accentColor
        ) {
            self.id = UUID()
            self.title = title
            self.date = date
            self.symbolName = symbolName
            self.symbolPickerPresented = symbolPickerPresented
            self.color = color
        }
    }
    
    enum Action: BindableAction, Equatable {
        case save
        case cancel
        case editModeChanged(EditMode)
        case binding(BindingAction<State>)
        case symbolValueChanged(String)
        case presentSymbolPicker
        case dismissSymbolPicker
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .binding:
            // TODO ! ! !
            break
            //state.sliderValue = .minimum(state.sliderValue, Double(state.stepCount))
        case let .editModeChanged(editMode):
            state.editMode = editMode
            return .none
        case .save, .cancel:
            // TODO ! ! !
            break
        case let .symbolValueChanged(value):
            print("symbol value changed")
            state.symbolName = value
        case .presentSymbolPicker:
            state.symbolPickerPresented = true
        case .dismissSymbolPicker:
            state.symbolPickerPresented = false
        }
        return .none
    }
}

struct EditDaisyView: View {
    
    let store: StoreOf<EditDaisy>
    //@State private var symbolPickerPresented = false
    // If still can't figure it out go back to using local binding for sheet
    
    init(store: StoreOf<EditDaisy>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                TextField("Title", text: viewStore.binding(\.$title))
                DatePicker(selection: viewStore.binding(\.$date), in: ...viewStore.date) {
                    Text("Select a date")
                }
                ColorPicker(selection: viewStore.binding(\.$color), supportsOpacity: true) {
                    Text("Select a color")
                }
                Button(action: {
                    viewStore.send(.presentSymbolPicker)
                }) {
                    HStack {
                        Text("Edit symbol")
                        Spacer()
                        Image(systemName: viewStore.symbolName)
                    }
                }
                .sheet(isPresented: viewStore.binding(get: \.symbolPickerPresented, send: EditDaisy.Action.dismissSymbolPicker)) {
                    SymbolPicker(symbol: viewStore.binding(get: \.symbolName, send: EditDaisy.Action.symbolValueChanged))
                }
            }
            .navigationTitle("Edit Daisy")
        }
    }
}
