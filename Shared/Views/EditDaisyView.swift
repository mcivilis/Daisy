//
//  EditDaisyView.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-10-15.
//

import SwiftUI
import ComposableArchitecture
import SymbolPicker

struct EditDaisyView: View {
    
    let store: StoreOf<Daisy>

    init(store: StoreOf<Daisy>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            NavigationStack {
                Form {
                    Section(header: Text("TITLE")) {
                        TextField("Title", text: viewStore.binding(get: \.title, send: Daisy.Action.titleChanged))
                            .font(.title2)
                    }
                    Section(header: Text("DETAILS")) {
                        DatePicker(selection: viewStore.binding(get: \.date, send: Daisy.Action.dateChanged)) {
                            Text("Date")
                        }
                        ColorPicker(selection: viewStore.binding(get: \.color, send: Daisy.Action.colorChanged)) {
                            Text("Color")
                        }
                        Button {
                            viewStore.send(.showSymbolPicker)
                        } label: {
                            HStack {
                                Text("Symbol")
                                Spacer()
                                if viewStore.symbol.isEmpty {
                                    Text("None")
                                } else {
                                    Image(systemName: viewStore.symbol)
                                }
                            }.foregroundColor(viewStore.color)
                        }

                    }
                }
                .sheet(isPresented: viewStore.binding(get: \.isShowingSymbolPicker, send: Daisy.Action.dismissSymbolPicker)) {
                    SymbolPicker(symbol: viewStore.binding(get: \.symbol, send: Daisy.Action.symbolChanged))
                }
                .navigationTitle("Daisy")
                .navigationBarItems(
                    trailing: Button("Done") {
                        viewStore.send(.dismissDetail)
                    }.buttonStyle(DaisyButtonStyle(color: viewStore.color))
                )
            }
        }
    }
}


struct EditDaisyView_Previews: PreviewProvider {
    
    static var store: Store<Daisy.State, Daisy.Action> = Store(
        initialState: Daisy.State(title: "Daisy 1", date: Date(timeIntervalSinceNow: -20), symbol: "pencil", color: .yellow),
        reducer: Daisy()
    )
    
    static var previews: some View {
        EditDaisyView(store: store)
    }
}
