//
//  DogsView.swift
//  TheDogApi
//
//  Created by Carlos Correa on 28/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct DogsView: View {
    let store: StoreOf<DogsReducer>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    List {
                        ForEachStore(
                            self.store.scope(state: { $0.dogs! },
                                             action: DogsReducer.Action.dog(id:action:))
                        ) { rowStore in
                            WithViewStore(rowStore, observe: \.dog) { rowViewStore in
                                NavigationLink(
                                    destination: DogsDetailView(store: Store(initialState:
                                                                                DogsDetailReducer.State(
                                                                                    dog: rowViewStore.state ),
                                                                             reducer: DogsDetailReducer() ))
                                ) {
                                    WithViewStore(rowStore) { rowViewStore in
                                        DogsListCell(store: rowStore)
                                            .onAppear() {
                                                if (rowViewStore.id == viewStore.lastDogId) {
                                                    viewStore.send(.loadMoreDogs)
                                                }
                                            }
                                    }
                                }
                            }
                        }
                        
                    }
                    .listStyle(.plain)
                    .navigationTitle("Dogs list")
                }
            }
            .onAppear {
                viewStore.send(.fetchDogs)
            }
        }
    }
}

struct DogsView_Previews: PreviewProvider {
    static var previews: some View {
        DogsView(
            store: Store(
                initialState: DogsReducer.State(dogs: []),
                reducer: DogsReducer()
            )
        )
    }
}
