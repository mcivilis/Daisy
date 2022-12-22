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
    case active = "Active"
    case past = "Past"
}

struct DaisyList: ReducerProtocol {
    
    struct State: Equatable {
        var editMode: EditMode = .inactive
        var filter: Filter = .all
        var daisies: IdentifiedArrayOf<Daisy.State> = []
        
        public var filteredDaisys: IdentifiedArrayOf<Daisy.State> {
            switch filter {
            case .active:
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
        case failedToSave(String)
        case succeededToSave
        case updateDaisies([Model])
        case newDaisy
        case clearCompleted
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
                            return .failedToSave(error.localizedDescription)
                        } else {
                            return .succeededToSave
                        }
                    }
            case .failedToSave:
                // TODO: Handle save error
                break
            case let .updateDaisies(models):
                state.daisies = IdentifiedArrayOf(uniqueElements: models.map {
                    Daisy.State(
                        id: $0.id,
                        title: $0.title,
                        date: $0.date,
                        symbolName: $0.symbolName,
                        color: Color.init(hex: $0.color) ?? .accentColor
                    )
                })
            case .newDaisy:
                // TODO Remove test code and actually make new real entry
                state.daisies.insert(Source.random, at: 0)
                return EffectTask(value: .save)
            case .clearCompleted:
                state.daisies.removeAll(where: \.isPast)
                return EffectTask(value: .save)
                
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
            case .selectDaisy(id: _, action: .showDetail):
                return .run { send in
                    try await self.clock.sleep(for: .seconds(1)) // MC: - why wait, better visually - test it out?
                    await send(.sortCompletedDaisys, animation: .default)
                }
                .cancellable(id: DaisyCompletionID.self, cancelInFlight: true) // MC: - need to understand this
            case .selectDaisy, .succeededToSave:
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
    @ObservedObject var viewStore: ViewStore<ViewState, DaisyList.Action>
    
    init(store: StoreOf<DaisyList>) {
        self.store = store
        self.viewStore = ViewStore(self.store.scope(state: ViewState.init(state:)))
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
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
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
                            ZStack {
                                NavigationLink(destination: EditView(store: store)) {
                                    EmptyView()
                                }.opacity(0)
                                DaisyView(store: store)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete { viewStore.send(.delete($0)) }
                    }
                    .listStyle(.plain)
                    .listRowSeparator(.hidden)
                }
                .onAppear { viewStore.send(.load) }
                .navigationTitle("Daisies")
                .navigationBarItems(
                    leading: HStack {
                        EditButton().buttonStyle(DaisyButtonStyle())
                        Button("Clear Past") {
                            viewStore.send(.clearCompleted)
                        }.buttonStyle(DaisyButtonStyle())
                    },
                    trailing: Button(action: {
                        viewStore.send(.newDaisy)
                    }, label: {
                        Image(systemName: "square.and.pencil")
                    }).buttonStyle(DaisyButtonStyle())
                )
                .environment(
                    \.editMode,
                     viewStore.binding(get: \.editMode, send: DaisyList.Action.editModeChanged)
                )
            }
        }
    }
}

extension IdentifiedArray where ID == Daisy.State.ID, Element == Daisy.State {
    static let mock: Self = [
        Daisy.State(title: "Daisy 1", date: Date(timeIntervalSinceNow: -20), symbolName: "", color: .accentColor),
        Daisy.State(title: "Daisy 2", date: Date(timeIntervalSinceNow: -10), symbolName: "", color: .accentColor),
        Daisy.State(title: "Daisy 3", date: Date(timeIntervalSinceNow: -0), symbolName: "", color: .accentColor),
        Daisy.State(title: "Daisy 4", date: Date(timeIntervalSinceNow: 10), symbolName: "", color: .accentColor),
        Daisy.State(title: "Daisy 5", date: Date(timeIntervalSinceNow: 20), symbolName: "", color: .accentColor),
    ]
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
