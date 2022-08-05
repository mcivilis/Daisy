//
//  DaisyAppView.swift
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

// MARK: - State

struct AppState: Equatable {
  var editMode: EditMode = .inactive
  var filter: Filter = .all
  var daisies: IdentifiedArrayOf<DaisyState> = []

  var filteredDaisys: IdentifiedArrayOf<DaisyState> {
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


// MARK: - Action
enum AppAction: Equatable {
  case newDaisy
  case clearCompleted
  case delete(IndexSet)
  case editModeChanged(EditMode)
  case filter(Filter)
  case move(IndexSet, Int)
  case sortCompletedDaisys
  case selectDaisy(id: DaisyState.ID, action: DaisyAction)
}

// MARK: - Environment
struct AppEnvironment {    
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var uuid: () -> UUID
    // TODO MC: - why do i need these properties?
    init(
        mainQueue: AnySchedulerOf<DispatchQueue> = .main,
        uuid: @escaping () -> UUID = UUID.init
    ) {
        self.mainQueue = mainQueue
        self.uuid = uuid
    }
}

// MARK: - Reducer

let daisyAppReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
  daisyReducer.forEach(
    state: \.daisies,
    action: /AppAction.selectDaisy(id:action:),
    environment: { _ in DaisyEnvironment() }
  ),
  Reducer { state, action, environment in
    switch action {
    case .newDaisy:
      state.daisies.insert(DaisyState(id: environment.uuid()), at: 0)
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
            .compactMap { state.daisies.index(id: $0.id) }
        )
        destination =
          state.daisies.index(id: state.filteredDaisys[destination].id)
          ?? destination
      }

      state.daisies.move(fromOffsets: source, toOffset: destination)

      return Effect(value: .sortCompletedDaisys)
        .delay(for: .milliseconds(100), scheduler: environment.mainQueue)
        .eraseToEffect()

    case .sortCompletedDaisys:
      state.daisies.sort { $1.isPast && !$0.isPast } // TODO MC: - sort by date
      return .none

    case .selectDaisy(id: _, action: .checkBoxToggled):
      enum DaisyCompletionId {}
      return Effect(value: .sortCompletedDaisys)
        .debounce(id: DaisyCompletionId.self, for: 1, scheduler: environment.mainQueue.animation())

    case .selectDaisy:
      return .none
    }
  }
)

// MARK: - View

struct DaisyAppView: View {
    
    let store: Store<AppState, AppAction>
    @ObservedObject var viewStore: ViewStore<ViewState, AppAction>
    
    init(store: Store<AppState, AppAction>) {
      self.store = store
      self.viewStore = ViewStore(self.store.scope(state: ViewState.init(state:)))
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Picker("Filter", selection: viewStore.binding(get: \.filter, send: AppAction.filter).animation()) {
                  ForEach(Filter.allCases, id: \.self) { filter in
                    Text(filter.rawValue).tag(filter)
                  }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                List {
                    ForEachStore(store.scope(state: \.filteredDaisys, action: AppAction.selectDaisy(id:action:))) {
                        DaisyView(store: $0)
                    }
                    .onDelete { viewStore.send(.delete($0)) }
                    .onMove { viewStore.send(.move($0, $1)) }
                }
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
              viewStore.binding(get: \.editMode, send: AppAction.editModeChanged)
            )
            // TODO MC: Deprecated - chose between NavigationStackView and NavigationSplitView
            // https://developer.apple.com/documentation/SwiftUI/Migrating-to-New-Navigation-Types
            // Watch: https://developer.apple.com/videos/play/wwdc2022/10054/
            .navigationViewStyle(.stack)
        }
    }
}

// MARK: - Extensions

extension DaisyAppView {
    
    struct ViewState: Equatable {
      let editMode: EditMode
      let filter: Filter
      let isClearCompletedButtonDisabled: Bool

      init(state: AppState) {
          self.editMode = state.editMode
          self.filter = state.filter
          self.isClearCompletedButtonDisabled = !state.daisies.contains(where: \.isPast)
      }
    }
}

extension IdentifiedArray where ID == DaisyState.ID, Element == DaisyState {
    static let mock: Self = [
        DaisyState(title: "Daisy 1", date: Date(timeIntervalSinceNow: -20)),
        DaisyState(title: "Daisy 2", date: Date(timeIntervalSinceNow: -10)),
        DaisyState(title: "Daisy 3", date: Date(timeIntervalSinceNow: -0)),
        DaisyState(title: "Daisy 4", date: Date(timeIntervalSinceNow: 10)),
        DaisyState(title: "Daisy 5", date: Date(timeIntervalSinceNow: 20)),
    ]
}

// MARK: - Preview

struct DaisyAppView_Previews: PreviewProvider {
    
    static var previews: some View {
        DaisyAppView(store: Store(
            initialState: AppState(daisies: .mock),
            reducer: daisyAppReducer,
            environment: AppEnvironment()
        ))
    }
}
