//
//  EditDaisyView.swift
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
        case binding(BindingAction<State>)
        case symbolValueChanged(String)
        case presentSymbolPicker
        case dismissSymbolPicker
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .binding:
            print("binding")
            break
        case .save, .cancel:
            print("save or cancel pressed")
            break
        case let .symbolValueChanged(value):
            print("symbol value changed")
            state.symbolName = value
        case .presentSymbolPicker:
            print("present symbol picker")
            state.symbolPickerPresented = true
        case .dismissSymbolPicker:
            print("dismiss symbol picker")
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
            
            NavigationStack {
                Form {
                    Section(header: Text("TITLE")) {
                        TextField("Title", text: viewStore.binding(\.$title))
                            .font(.title2)
                    }
                    Section(header: Text("DETAILS")) {
                        DatePicker(selection: viewStore.binding(\.$date)) {
                            Text("Date")
                        }
                        ColorPicker(selection: viewStore.binding(\.$color), supportsOpacity: true) {
                            Text("Color")
                        }
                        Button(action: {
                            viewStore.send(.presentSymbolPicker)
                        }) {
                            HStack {
                                Text("Symbol")
                                Spacer()
                                Image(systemName: viewStore.symbolName)
                            }
                        }
                    }
                }
                .sheet(isPresented: viewStore.binding(get: \.symbolPickerPresented, send: EditDaisy.Action.dismissSymbolPicker)) {
                    SymbolPicker(symbol: viewStore.binding(get: \.symbolName, send: EditDaisy.Action.symbolValueChanged))
                }
                .navigationTitle("Edit Daisy")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        viewStore.send(.cancel)
                    }.buttonStyle(DaisyButtonStyle()),
                    trailing: Button("Save") {
                        viewStore.send(.save)
                    }.buttonStyle(DaisyButtonStyle())
                )
            }
        }
    }
}
struct EditDaisyView_Previews: PreviewProvider {
    
    static var store: Store<EditDaisy.State, EditDaisy.Action> = Store(
        initialState: EditDaisy.State(),
        reducer: EditDaisy()
    )
    
    static var previews: some View {
        EditDaisyView(store: store)
    }
}
