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
                                .shadow(color: .black, radius: 2)
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
                                // TODO: show more date formats
                            }
                            .buttonStyle(DaisyButtonStyle())
//                            Text(viewStore.date.daisy())
//                                .foregroundColor(.black)
//                                .padding(8)
//                                .background(.white)
//                                .cornerRadius(20)
//                                .shadow(color: .black, radius: 2)
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
