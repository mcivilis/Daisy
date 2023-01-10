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
        var symbol: String
        var color: Color
        
        var isPast: Bool {
            return date <= Date.now
        }
        
        var isShowingDetail: Bool = false
        var isShowingSymbolPicker: Bool = false
        
        init(
            id: UUID = UUID(),
            title: String,
            date: Date,
            symbol: String,
            color: Color
        ) {
            self.id = id
            self.title = title
            self.date = date
            self.symbol = symbol
            self.color = color
        }
    }
    
    enum Action: Equatable {
        case showDetail
        case dismissDetail
        case showSymbolPicker
        case dismissSymbolPicker
        case titleChanged(String)
        case dateChanged(Date)
        case colorChanged(Color)
        case symbolChanged(String)
    }
    
    struct Environment {}
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        switch action {
        case .showDetail:
            state.isShowingDetail = true
        case .dismissDetail:
            state.isShowingDetail = false
        case let .titleChanged(text):
            state.title = text
        case let .dateChanged(date):
            state.date = date
        case let .colorChanged(color):
            state.color = color
        case let .symbolChanged(symbol):
            state.symbol = symbol
            state.isShowingSymbolPicker = false
        case .showSymbolPicker:
            state.isShowingSymbolPicker = true
        case .dismissSymbolPicker:
            state.isShowingSymbolPicker = false
        }
        return .none
    }
}

// MARK: View

struct DaisyView: View {
    let store: StoreOf<Daisy>
    private let heights = stride(from: 0.5, through: 1.0, by: 0.1).map { PresentationDetent.fraction($0) }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            RoundedRectangle(cornerRadius: 25)
                .strokeBorder(viewStore.color, lineWidth: 2)
                .shadow(radius: 10)
                .frame(height: 100)
                .overlay {
                    HStack {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(viewStore.title)
                                .font(.title2   )
                                .fontWeight(.bold)
                                .foregroundColor(viewStore.color)
                            Text(viewStore.date.display())
                                .font(.body)
                        }
                        .padding()
                        Spacer()
                        VStack(alignment: .center, spacing: 12) {
                            Image(systemName: viewStore.symbol)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(viewStore.color)
                            Text(viewStore.date.daisy())
                                .capsuleStyle(color: viewStore.color)
                        }
                        .offset(y: 20)
                    }
                }
                .padding(.bottom, 20)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewStore.send(.showDetail)
                }
                .sheet(isPresented: viewStore.binding(get: \.isShowingDetail, send: Daisy.Action.dismissDetail), content: {
                    EditDaisyView(store: store)
                        .presentationDetents(Set(heights))
                        .presentationDragIndicator(.hidden)
                })
        }
    }
}

struct DaisyItemView_Previews: PreviewProvider {
    static var store: Store<Daisy.State, Daisy.Action> = Store(
        initialState: Daisy.State(
            title: "Amelia's Birthday",
            date: Date.preview("2:32 Wed, 22 Sep 2019"),
            symbol: "birthday.cake.fill",
            color: .accentColor
        ),
        reducer: Daisy()
    )
    
    static var previews: some View {
        DaisyView(store: store)
    }
}
