//
//  DogsReducer.swift
//  TheDogApi
//
//  Created by Carlos Correa on 27/05/2023.
//

import Foundation
import ComposableArchitecture
import OrderedCollections

struct DogsReducer: ReducerProtocol {
    
    struct State: Equatable {
        var isLoading: Bool = true
        var isLoadingMore: Bool = true
        var currentPage: Int = 0
        
        var dogs: IdentifiedArrayOf<DogsListCellReducer.State>?
        
        var lastDogId: UUID {
            return dogs?.last?.id ?? UUID()
        }
    }
    
    enum Action {
        case close
        case fetchDogs
        case fetchDogsResponse(TaskResult<Dogs>)
        case loadMoreDogs
        case dog(id: DogsListCellReducer.State.ID, action: DogsListCellReducer.Action)
    }
    
    @Dependency(\.dogsApiClient) var dogsApiClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .dog(id: _, action: _):
                return .none
            case .loadMoreDogs:
                state.currentPage += 1
                state.isLoadingMore = true
                return .run { send in await send(.fetchDogs) }
            case .fetchDogs:
                let page  = state.currentPage
                return .task {
                    await .fetchDogsResponse(
                        TaskResult { try await dogsApiClient.fetchDogs("", page) }
                    )
                }
            case .fetchDogsResponse(.failure(let error)):
                print(error)
                return .none
            case .fetchDogsResponse(.success(let dogs)):
                
                let fetchedDogs = IdentifiedArrayOf<DogsListCellReducer.State>(
                    uniqueElements: dogs.map { dog in
                        return DogsListCellReducer.State(id: UUID(), dog: dog)
                    })
                
                if state.dogs != nil && state.isLoadingMore {
                    var currentDogs = state.dogs
                    currentDogs?.append(contentsOf: fetchedDogs)
                    state.dogs = currentDogs
                    state.isLoadingMore = false
                } else {
                    state.dogs = fetchedDogs
                }
                
                print(dogs)
                return .none
            case .close:
                return .none
            }
        }
    }
    
}
