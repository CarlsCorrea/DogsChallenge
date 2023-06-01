//
//  DogsSearchView.swift
//  TheDogApi
//
//  Created by Carlos Correa on 30/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct DogsSearchView: View {
    let store: StoreOf<DogsSearchReducer>
    var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: twoColumnGrid, alignment: .center, spacing: 10) {

                        ForEachStore(
                            self.store.scope(state: { $0.dogs ?? IdentifiedArrayOf<DogsSearchCellReducer.State>() },
                                             action: DogsSearchReducer.Action.dog(id:action:))
                        ) { rowStore in
                            WithViewStore(rowStore, observe: \.dog) { rowViewStore in
                                NavigationLink(
                                    destination: DogsDetailView(store: Store(initialState:
                                                                                DogsDetailReducer.State(
                                                                                    dog: rowViewStore.state ),
                                                                             reducer: DogsDetailReducer() ))
                                ) {
                                    WithViewStore(rowStore) { rowViewStore in
                                        DogsSearchCell(store: rowStore)
                                    }
                                }
                            }
                        }
                    }
                    .searchable(text: viewStore.binding(get: \.searchQuery, send: DogsSearchReducer.Action.searchQueryChanged))
                }
                .padding(.all, 10)
                .listStyle(.plain)
                .navigationTitle("Dogs list")
            }
        }
    }
}

struct DogsSearchView_Previews: PreviewProvider {
    static var previews: some View {
        DogsSearchView(
            store: Store(
                initialState: DogsSearchReducer.State(dogs: []),
                reducer: DogsSearchReducer()
            )
        )
    }
}
