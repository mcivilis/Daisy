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
                            viewStore.send(.showImageGenerator)
                        } label: {
                            HStack {
                                Text("Image")
                                Spacer()
                                if let data = viewStore.imageData, let image = Image(data: data) {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                } else {
                                    Text("None")
                                }
                            }.foregroundColor(viewStore.color)
                        }

                    }
                }
                .sheet(isPresented: viewStore.binding(get: \.isShowingImageGenerator, send: Daisy.Action.dismissImageGenerator)) {
                    ImageGeneratorView(store: store)
                }
                .navigationTitle("Daisy")
                .navigationBarItems(
                    trailing: Button("Done") {
                        viewStore.send(.dismissDetail)
                    }.buttonStyle(CapsuleButtonStyle(color: viewStore.color))
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
