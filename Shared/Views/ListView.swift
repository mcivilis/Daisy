//
//  ListView.swift
//  Shared
//
//  Created by Maria Civilis on 2022-07-15.
//

import ComposableArchitecture
import SwiftUI

enum Filter: LocalizedStringKey, CaseIterable, Hashable {
    case all = "All"
    case future = "Future"
    case past = "Past"
}

struct DaisyList: ReducerProtocol {
    
    struct State: Equatable {
        var editMode: EditMode = .inactive
        var filter: Filter = .all
        var daisies: IdentifiedArrayOf<Daisy.State> = []
        
        public var filteredDaisys: IdentifiedArrayOf<Daisy.State> {
            switch filter {
            case .future:
                return daisies.filter { !$0.isPast }
            case .all:
                return daisies
            case .past:
                return daisies.filter { $0.isPast }
            }
        }
    }
    
    enum Action: Equatable {
        case load
        case save
        case saveFailure(String)
        case saveSuccess
        case updateDaisies([Model])
        case newDaisy
        case delete(IndexSet)
        case editModeChanged(EditMode)
        case filter(Filter)
        case sortCompletedDaisys
        case selectDaisy(id: Daisy.State.ID, action: Daisy.Action)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.uuid) var uuid
    
    let daisySource: Source
    
    private enum DaisyCompletionID {}
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .load:
                return daisySource
                    .loadPublisher()
                    .map { daisies in
                        return .updateDaisies(daisies)
                    }
            case .save:
                return daisySource
                    .savePublisher(state.daisies)
                    .catchToEffect { result in
                        if case let .failure(error) = result {
                            return .saveFailure(error.localizedDescription)
                        } else {
                            return .saveSuccess
                        }
                    }
            case let .updateDaisies(models):
                state.daisies = IdentifiedArrayOf(uniqueElements: models.map {
                    Daisy.State(
                        id: $0.id,
                        title: $0.title,
                        date: $0.date,
                        symbol: $0.symbol,
                        color: Color.init(hex: $0.color) ?? .yellow
                    )
                })
            case .newDaisy:
                state.filter = .all
                let newDaisy = Daisy.State(title: "", date: .now, symbol: "", color: .yellow)
                state.daisies.insert(newDaisy, at: 0)
                return EffectTask(value: .selectDaisy(id: newDaisy.id, action: Daisy.Action.showDetail))
            case let .delete(indexSet):
                state.daisies.remove(atOffsets: indexSet)
                return EffectTask(value: .save)
                
            case let .editModeChanged(editMode):
                state.editMode = editMode
                return .none
                
            case let .filter(filter):
                state.filter = filter
                return .none
            case .sortCompletedDaisys:
                state.daisies.sort  { $0.date < $1.date }
                return .none
            case .selectDaisy:
                return EffectTask(value: .save)
            case .saveFailure, .saveSuccess:
                break
            }
            return .none
        }
        .forEach(\.daisies, action: /Action.selectDaisy(id:action:)) {
            Daisy()
        }
    }
}

// MARK: - View

struct ListView: View {
    let store: StoreOf<DaisyList>
    
    init(store: StoreOf<DaisyList>) {
        self.store = store
    }
    
    struct ViewState: Equatable {
        let editMode: EditMode
        let filter: Filter
        let isClearCompletedButtonDisabled: Bool
        
        init(state: DaisyList.State) {
            self.editMode = state.editMode
            self.filter = state.filter
            self.isClearCompletedButtonDisabled = !state.daisies.contains(where: \.isPast)
        }
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                ZStack {
                    VStack(alignment: .leading) {
                        Picker("Filter", selection: viewStore.binding(get: \.filter, send: DaisyList.Action.filter).animation()) {
                            ForEach(Filter.allCases, id: \.self) { filter in
                                Text(filter.rawValue).tag(filter)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        List {
                            ForEachStore(store.scope(state: \.filteredDaisys, action: DaisyList.Action.selectDaisy(id:action:))) { store in
                                DaisyView(store: store)
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                            }
                            .onDelete { viewStore.send(.delete($0)) }
                        }
                        .listStyle(.plain)
                        .listRowSeparator(.hidden)
                    }
                }
                .onAppear { viewStore.send(.load) }
                .navigationTitle("Daisies")
                .navigationBarItems(
                    leading: EditButton().buttonStyle(DaisyButtonStyle(color: .yellow)).buttonStyle(DaisyButtonStyle(color: .accentColor)),
                    trailing: Button(action: {
                        viewStore.send(.newDaisy)
                    }, label: {
                        Image(systemName: "square.and.pencil")
                    }).buttonStyle(DaisyButtonStyle(color: .accentColor))
                )
                .environment(
                    \.editMode,
                     viewStore.binding(get: \.editMode, send: DaisyList.Action.editModeChanged)
                )
            }
        }
    }
}

// MARK: - Preview

struct DaisyAppView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(
            store: Store(
                initialState: DaisyList.State(),
                reducer: DaisyList(daisySource: Source())
            )
        )
    }
}
