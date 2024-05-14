//
//  EditDaisyView.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-10-15.
//

import SwiftUI
import ComposableArchitecture

struct EditDaisyView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let store: StoreOf<Daisy>

    init(store: StoreOf<Daisy>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                Form {
                    Section {
                        TextField("Title", text: viewStore.binding(get: \.title, send: Daisy.Action.titleChanged))
                            .font(.title2)
                    } header: {
                        Text("TITLE")
                    }
                    Section {
                        DatePicker("Date", selection: viewStore.binding(get: \.date, send: Daisy.Action.dateChanged))
                        Button {
                            viewStore.send(.showSymbolPicker)
                        } label: {
                            HStack {
                                Text("Symbol")
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(colorScheme == .dark ? Theme.muted.light : Theme.muted.dark)
                        .overlay(alignment: .trailing) {
                            IconView(icon: viewStore.icon, color: .accentColor)
                        }
                    } header: {
                        Text("DETAILS")
                    }
                }
            }
            .navigationTitle("Countdown")
            .toolbar {
                Button("Done") {
                    viewStore.send(.dismissDetail)
                }
                .buttonStyle(.capsule(.bright))
            }
            .sheet(isPresented: viewStore.binding(get: \.isShowingIconPicker, send: Daisy.Action.dismissSymbolPicker)) {
                IconPickerView(
                    color: Theme.bright.dark,
                    icon: viewStore.binding(get: \.icon, send: Daisy.Action.iconChanged)
                )
            }
        }
    }
}

struct EditDaisyView_Previews: PreviewProvider {
    
    static var previews: some View {
        EditDaisyView(store: .preview)
    }
}
