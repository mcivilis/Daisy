//
//  DaisyListView.swift
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
        var daisies: IdentifiedArrayOf<ListItem.State> = []
        
        var filteredDaisys: IdentifiedArrayOf<ListItem.State> {
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
        case newDaisy
        case clearCompleted
        case delete(IndexSet)
        case editModeChanged(EditMode)
        case filter(Filter)
        case move(IndexSet, Int)
        case sortCompletedDaisys
        case selectDaisy(id: ListItem.State.ID, action: ListItem.Action)
    }
    
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var uuid: () -> UUID
    
    init(
        mainQueue: AnySchedulerOf<DispatchQueue> = .main,
        uuid: @escaping () -> UUID = UUID.init
    ) {
        self.mainQueue = mainQueue
        self.uuid = uuid
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .newDaisy:
                // TODO
                // state.daisies.insert(DaisyState(id: environment.uuid()), at: 0)
                return .none
                
            case .clearCompleted:
                state.daisies.removeAll(where: \.isPast)
                return .none
                
            case let .delete(indexSet):
                state.daisies.remove(atOffsets: indexSet)
                return .none
                
            case let .editModeChanged(editMode):
                state.editMode = editMode
                return .none
                
            case let .filter(filter):
                state.filter = filter
                return .none
                
            case var .move(source, destination):
                if state.filter != .all {
                    source = IndexSet(
                        source
                            .map { state.filteredDaisys[$0] }
                            .compactMap { state.daisies.firstIndex(of: $0) }
                    )
                    destination = state.daisies.firstIndex(of: state.filteredDaisys[destination]) ?? destination
                }
                
                state.daisies.move(fromOffsets: source, toOffset: destination)
                
                return Effect(value: .sortCompletedDaisys)
                    .delay(for: .milliseconds(100), scheduler: self.mainQueue)
                    .eraseToEffect()
                
            case .sortCompletedDaisys:
                state.daisies.sort { $1.isPast && !$0.isPast } // TODO - sort by date
                return .none
                
            case .selectDaisy(id: _, action: .showDetail): // TODO - what should happen here?
                enum DaisyCompletionId {}
                return Effect(value: .sortCompletedDaisys)
                    .debounce(id: DaisyCompletionId.self, for: 1, scheduler: self.mainQueue.animation())
                
            case .selectDaisy:
                return .none
            }
        }
        .forEach(\.daisies, action: /Action.selectDaisy(id:action:)) {
            ListItem()
        }
    }
}

// MARK: - View

struct DaisyListView: View {
    
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
                        NavigationLink {
                            DaisyView()
                        } label: {
                            ListItemView(store: store)
                        }
                    }
                    .onDelete { viewStore.send(.delete($0)) }
                    .onMove { viewStore.send(.move($0, $1)) }
                }
                .listStyle(.inset)
            }
            .navigationTitle("Daisies")
            .navigationBarItems(
                leading: HStack {
                    EditButton()
                    Button("Clear Completed") {
                        viewStore.send(.clearCompleted)
                    }
                },
                trailing: Button(action: {
                    viewStore.send(.newDaisy)
                }, label: {
                    Image(systemName: "square.and.pencil")
                })
            )
            .environment(
                \.editMode,
                 viewStore.binding(get: \.editMode, send: DaisyList.Action.editModeChanged)
            )
        }
    }
}

extension IdentifiedArray where ID == ListItem.State.ID, Element == ListItem.State {
    static let mock: Self = [
        ListItem.State(title: "Daisy 1", date: Date(timeIntervalSinceNow: -20)),
        ListItem.State(title: "Daisy 2", date: Date(timeIntervalSinceNow: -10)),
        ListItem.State(title: "Daisy 3", date: Date(timeIntervalSinceNow: -0)),
        ListItem.State(title: "Daisy 4", date: Date(timeIntervalSinceNow: 10)),
        ListItem.State(title: "Daisy 5", date: Date(timeIntervalSinceNow: 20)),
    ]
}

// MARK: - Preview

struct DaisyAppView_Previews: PreviewProvider {
    static var previews: some View {
        DaisyListView(
            store: Store(
                initialState: DaisyList.State(daisies: .mock),
                reducer: DaisyList()
            )
        )
    }
}
