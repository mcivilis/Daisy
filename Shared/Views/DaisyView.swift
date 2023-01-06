//
//  DaisyView.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-07-29.
//

import SwiftUI
import ComposableArchitecture
import IdentifiedCollections

// MARK: Reducer

struct Daisy: ReducerProtocol {
    
    struct State: Equatable, Identifiable {
        let id: UUID
        var title: String
        var date: Date
        var symbolName: String
        var color: Color
        
        var isPast: Bool {
            return date >= Date.now
        }
        
        var editDaisyState: EditDaisy.State?
        
        init(
            id: UUID = UUID(),
            title: String,
            date: Date,
            symbolName: String,
            color: Color
        ) {
            self.id = id
            self.title = title
            self.date = date
            self.symbolName = symbolName
            self.color = color
        }
    }
    
    enum Action: Equatable {
        case showDetail
        case dismissDetail
        case editDaisyAction(EditDaisy.Action)
        case delete
    }
    
    struct Environment {}
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        switch action {
        case .showDetail:
            state.editDaisyState = EditDaisy.State(
                title: state.title,
                date: state.date,
                symbolName: state.symbolName,
                color: state.color
            )
        case .delete, .editDaisyAction, .dismissDetail:
            // TODO ! ! !
            break
        }
        return .none
    }
}

// MARK: View

struct DaisyView: View {
    let store: StoreOf<Daisy>
    private let heights = stride(from: 0.4, through: 1.0, by: 0.1).map { PresentationDetent.fraction($0) }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            RoundedRectangle(cornerRadius: 25)
                .strokeBorder(Color.stroke, lineWidth: 2)
                .shadow(radius: 10)
                .frame(height: 100)
                .overlay {
                    HStack {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(viewStore.title)
                                .font(.title2   )
                                .fontWeight(.bold)
                                .foregroundColor(Color.header)
                            Text(viewStore.date.display())
                                .font(.body)
                        }
                        .padding()
                        Spacer()
                        VStack(alignment: .center, spacing: 12) {
                            if let symbolName = viewStore.symbolName {
                                Image(systemName: symbolName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Color.foreground)
                                    .shadow(color: .black, radius: 2)
                                    

                            }
                            Button(viewStore.date.daisy()) {
                                // TODO: replace this with a Text capsule as this is not a functioning button
                            }
                            .buttonStyle(DaisyButtonStyle())
                        }
                        .offset(y: 20)
                    }
                }
                .padding(.bottom, 20)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewStore.send(.showDetail)
                }
                .sheet(item: viewStore.binding(get: \.editDaisyState, send: Daisy.Action.dismissDetail)) { id in
                    IfLetStore(store.scope(state: \.editDaisyState, action: Daisy.Action.editDaisyAction)) { store in
                        EditDaisyView(store: store)
                            .presentationDetents(Set(heights))
                            .presentationDragIndicator(.hidden)
                    }
                }
        }
    }
}

struct DaisyItemView_Previews: PreviewProvider {
    static var store: Store<Daisy.State, Daisy.Action> = Store(
        initialState: Daisy.State(
            title: "Amelia's Birthday",
            date: Date.preview("2:32 Wed, 22 Sep 2019"),
            symbolName: "birthday.cake.fill",
            color: .accentColor
        ),
        reducer: Daisy()
    )
    
    static var previews: some View {
        DaisyView(store: store)
    }
}
