//
//  DaisyView.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-10-15.
//

import SwiftUI
import ComposableArchitecture

struct Daisy: ReducerProtocol {
    
    struct State: Equatable {
        let id: UUID
        var title: String
        var date: Date
        var symbolName: String?
        var color: Color
        
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
        case save
        case cancel
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .save:
            break
        case .cancel:
            break
        }
        return .none
    }
}

struct DaisyView: View {
    
    @BindableState
    var daisyState: DaisyItemState
    
    init(daisyState: DaisyItemState = DaisyItemState()) {
        self.daisyState = daisyState
    }
    
    var body: some View {
        Form {
            Text("Hello")
            //TextField("Title", text: daisyState.title)
        }
    }
}

struct DaisyView_Previews: PreviewProvider {
    static var previews: some View {
        DaisyView()
    }
}
