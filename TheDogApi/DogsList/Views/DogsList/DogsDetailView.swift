//
//  DogsDetailView.swift
//  TheDogApi
//
//  Created by Carlos Correa on 28/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct DogsDetailReducer: ReducerProtocol {
    struct State: Equatable {
        var dog: Dog
    }
    
    enum Action {
        case close
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .close:
                return .none
            }
        }
    }
}

struct DogsDetailView: View {
    let store: StoreOf<DogsDetailReducer>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                Text("Name:")
                Text(viewStore.dog.name)
            }
            .padding()
            
            VStack {
                Text("Group:")
                Text(viewStore.dog.breedGroup ?? "without group")
            }
            .padding()
            
            VStack {
                Text("Origin:")
                Text(viewStore.dog.origin ?? "without origin")
            }
            .padding()
            
            VStack {
                Text("Temperament:")
                Text(viewStore.dog.temperament ?? "without temperament")
            }
            .padding()
        }
    }
}

struct DogsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DogsDetailView(
            store: Store(
                initialState: DogsDetailReducer.State(dog: Dog.sample),
                reducer: DogsDetailReducer()
            )
        )
    }
}
