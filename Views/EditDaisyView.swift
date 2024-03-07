//
//  EditDaisyView.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-10-15.
//

import SwiftUI
import ComposableArchitecture

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
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(viewStore.color)
                        .overlay(alignment: .trailing) {
                            IconView(icon: viewStore.icon, color: viewStore.color)
                        }
                    }
                }
                .navigationTitle("Daisy")
                .navigationBarItems(
                    trailing: Button("Done") {
                        viewStore.send(.dismissDetail)
                    }.buttonStyle(.capsule(viewStore.color))
                )
                .sheet(isPresented: viewStore.binding(get: \.isShowingIconPicker, send: Daisy.Action.dismissSymbolPicker)) {
                    IconPickerView(
                        color: viewStore.state.color,
                        icon: viewStore.binding(get: \.icon, send: Daisy.Action.iconChanged)
                    )
                }
            }
        }
    }
}


struct EditDaisyView_Previews: PreviewProvider {
    
    static var previews: some View {
        EditDaisyView(store: .preview)
    }
}
