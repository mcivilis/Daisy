//
//  ImageGeneratorView.swift
//  Daisy (iOS)
//
//  Created by Maria Civilis on 2023-03-13.
//

import SwiftUI
import ComposableArchitecture

// MARK: Reducer
struct ImageGenerator: ReducerProtocol {
    
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case cancel
        case save
        case imageGenerated(Data)
    }
    
    struct Environment {}
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        switch action {
        case .cancel:
            break
        case .save:
            break
        case .imageGenerated(_):
            break
        }
        return .none
    }
}

// MARK: View
struct ImageGeneratorView: View {
    
    let store: StoreOf<Daisy>
    
    init(store: StoreOf<Daisy>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                VStack {
                    Text("This image generator is using OpenAI, please enter a text description of the desired image.")
                        .font(.subheadline)
                        .padding()
                    
                    TextField("Description",
                              text: viewStore.binding(
                                get: \.imageDescription,
                                send: Daisy.Action.imageDescriptionChanged
                              ),
                              axis: .vertical
                    )
                    .font(.title2)
                    .padding()
                    Button {
                        viewStore.send(.generateImage)
                    } label: {
                        ZStack {
                            Text("Generate!")
                        }
                    }.disabled(viewStore.state.imageIsLoading)
                        .buttonStyle(CapsuleButtonStyle(color: viewStore.color))
                        .font(.title2)
                        .padding()
                    
                    if let data = viewStore.imageData, let image = Image(data: data) {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    Spacer()
                }
                .if(viewStore.state.imageIsLoading) { view in
                    view
                        .blur(radius: 15)
                        .overlay {
                            DaisySpinner()
                        }
                }
                .navigationTitle("Generate Image")
                .toolbar {
                    ToolbarItem {
                        Button("Done") {
                            viewStore.send(.dismissImageGenerator)
                        }.buttonStyle(CapsuleButtonStyle(color: viewStore.color))
                    }
                }
            }
        }
    }
}

struct ImageGeneratorView_Previews: PreviewProvider {
    
    static var previews: some View {
        ImageGeneratorView(store: .preview)
    }
}
