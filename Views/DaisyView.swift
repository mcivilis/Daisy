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
        var icon: Icon
        var color: Color
        
        var isPast: Bool {
            return date <= Date.now
        }
        
        var isShowingTimeDetail: Bool = false
        var isShowingDetail: Bool = false
        var isShowingIconPicker: Bool = false
        
        init(
            id: UUID = UUID(),
            title: String,
            date: Date,
            icon: Icon,
            color: Color
        ) {
            self.id = id
            self.title = title
            self.date = date
            self.icon = icon
            self.color = color
        }
    }
    
    enum Action {
        case showTimeDetail
        case showDetail
        case dismissDetail
        case dismissSymbolPicker
        case dismissTimeDetail
        case showSymbolPicker
        case iconChanged(Icon)
        case titleChanged(String)
        case dateChanged(Date)
        case colorChanged(Color)
    }
    
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
        case .showSymbolPicker:
            state.isShowingIconPicker = true
        case let .iconChanged(icon):
             state.icon = icon
             state.isShowingIconPicker = false
        case .dismissSymbolPicker:
            state.isShowingIconPicker = false
        case .showTimeDetail:
            state.isShowingTimeDetail = true
        case .dismissTimeDetail:
            state.isShowingTimeDetail = false
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
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text(viewStore.title)
                        .font(.title2   )
                        .fontWeight(.bold)
                        .foregroundColor(viewStore.color)
                    Text(viewStore.date.display())
                        .font(.body)
                    Text(viewStore.date.daisy())
                        .font(.caption)
                        .fontWeight(.bold)
                }.padding()
                Spacer()
                VStack(alignment: .center, spacing: 12) {
                    IconView(icon: viewStore.icon, color: viewStore.color)
                    Button(viewStore.date.display()) {
                        viewStore.send(.showTimeDetail)
                    }
                    .buttonStyle(.capsule(viewStore.color))
                }
                .offset(y: 20)
            }
            .frame(height: 125)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .overlay {
                RoundedRectangle(cornerRadius: 25)
                    .strokeBorder(viewStore.color, lineWidth: 3)
                    .shadow(radius: 10)
                    .frame(height: 125)
                    .foregroundColor(.clear)
            }
                .onTapGesture {
                    viewStore.send(.showDetail)
                }
                .sheet(isPresented: viewStore.binding(get: \.isShowingDetail, send: Daisy.Action.dismissDetail), content: {
                    EditDaisyView(store: store)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.hidden)
                })
                .sheet(isPresented: viewStore.binding(get: \.isShowingTimeDetail, send: Daisy.Action.dismissTimeDetail), content: {
                    TimeDetailView(store: store)
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
            icon: .preview,
            color: .yellow
        ),
        reducer: Daisy()
    )
    
    static var previews: some View {
        DaisyView(store: store)
    }
}
