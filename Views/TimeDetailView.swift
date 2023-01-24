//
//  TimeDetailView.swift
//  Daisy (iOS)
//
//  Created by Maria Civilis on 2023-01-24.
//

import SwiftUI
import ComposableArchitecture

// MARK: Reducer

struct TimeDetail: ReducerProtocol {
    struct State: Equatable, Identifiable {
        let id: UUID
        let date: Date
        
        init(
            id: UUID,
            date: Date
        ) {
            self.id = id
            self.date = date
        }
    }
    
    enum Action: Equatable {
        // Coming Soon...
    }
    
    struct Environment {}
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
    }
}
struct TimeDetailView: View {
    
    let store: StoreOf<TimeDetail>

    init(store: StoreOf<TimeDetail>) {
        self.store = store
    }
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct TimeDetailView_Previews: PreviewProvider {
    
    static var store: Store<TimeDetail.State, TimeDetail.Action> = Store(
        initialState: TimeDetail.State(id: UUID(), date: .now),
        reducer: TimeDetail()
    )
    
    static var previews: some View {
        TimeDetailView(store: store)
    }
}
