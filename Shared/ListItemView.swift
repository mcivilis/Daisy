//
//  ListItemView.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-07-29.
//

import SwiftUI
import ComposableArchitecture
import IdentifiedCollections

// MARK: Reducer

struct ListItem: ReducerProtocol {
    
    struct State: Equatable, Identifiable {
        let id: UUID
        var title: String
        var date: Date
        var symbolName: String?
        var color: Color
        
        var isPast: Bool {
            return date >= Date.now
        }
        
        init(
            title: String = "",
            date: Date = .now,
            symbolName: String? = nil,
            color: Color = Color.accentColor
        ) {
            self.id = UUID()
            self.title = title
            self.date = date
            self.symbolName = symbolName
            self.color = color
        }
    }
    
    enum Action: Equatable {
        case showDetail
        case delete
    }
    
    struct Environment {}
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        switch action {
        case .showDetail:
            break
        case .delete:
            break
        }
        return .none
    }
}

// MARK: View

struct ListItemView: View {
    let store: StoreOf<ListItem>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.accentColor)
                .frame(height: 100)
                .overlay {
                    HStack {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(viewStore.title)
                                .font(.title3)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                            Text(viewStore.date.display())
                                .foregroundColor(.black)
                                .font(.body)
                        }
                        .opacity(0.7)
                        .padding()
                        Spacer()
                        VStack(alignment: .center, spacing: 12) {
                            if let symbolName = viewStore.symbolName {
                                Image(systemName: symbolName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.black)
                                    .opacity(0.7)
                            }
                            Text(viewStore.date.daisy())
                                .foregroundColor(.white)
                                .padding(8)
                                .background(.black)
                                .cornerRadius(20)
                                .opacity(0.8)
                        }
                        .offset(y: 20)
                    }
                }
                .padding(.bottom, 20)
        }
    }
}

struct DaisyItemView_Previews: PreviewProvider {
    static var store: Store<ListItem.State, ListItem.Action> = Store(
        initialState: ListItem.State(
            title: "Amelia's Birthday",
            date: Date.preview("2:32 Wed, 22 Sep 2019"),
            symbolName: "birthday.cake.fill"
        ),
        reducer: ListItem()
    )
    
    static var previews: some View {
        ListItemView(store: store)
    }
}
