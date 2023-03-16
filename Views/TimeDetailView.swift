//
//  TimeDetailView.swift
//  Daisy (iOS)
//
//  Created by Maria Civilis on 2023-01-24.
//

import SwiftUI
import ComposableArchitecture

struct TimeDetailView: View {
    
    private struct DateComponent: View {
        
        let label: LocalizedStringKey
        let component: Calendar.Component
        let date: Date
        
        var body: some View {
            HStack {
                Text(label)
                Spacer()
                Text("\(Calendar.current.component(component, from: date))")
            }
        }
    }
    
    let store: StoreOf<Daisy>

    init(store: StoreOf<Daisy>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section("Since Now") {
                    DateComponent(label: "Years", component: .year, date: viewStore.state.date)
                    DateComponent(label: "Months", component: .month, date: viewStore.state.date)
                    DateComponent(label: "Days", component: .day, date: viewStore.state.date)
                }
            }
        }
    }
}

struct TimeDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        TimeDetailView(store: .preview)
    }
}
