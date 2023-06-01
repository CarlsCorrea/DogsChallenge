//
//  DogsSearchReducer.swift
//  TheDogApi
//
//  Created by Carlos Correa on 30/05/2023.
//

import Foundation
import ComposableArchitecture

struct DogsSearchReducer: ReducerProtocol {
    
    struct State: Equatable {
        var isLoading: Bool = true
        var isLoadingMore: Bool = true
        var currentPage: Int = 0
        var searchQuery = ""
        
        var dogs: IdentifiedArrayOf<DogsSearchCellReducer.State>?
        
        var lastDogId: UUID {
            return dogs?.last?.id ?? UUID()
        }
    }
    
    enum Action {
        case close
        case fetchDogs(String)
        case fetchDogsResponse(TaskResult<Dogs>)
        case loadMoreDogs
        case dog(id: DogsSearchCellReducer.State.ID, action: DogsSearchCellReducer.Action)
        
        // searchQuery
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        case searchResponse(TaskResult<Dogs>)

    }
    
    @Dependency(\.dogsApiClient) var dogsApiClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .searchResponse(.success(let dogs)):
                let fetchedDogs = IdentifiedArrayOf<DogsSearchCellReducer.State>(
                    uniqueElements: dogs.map { dog in
                        return DogsSearchCellReducer.State(id: UUID(), dog: dog)
                    })
                
                state.dogs = fetchedDogs
            
                return .none
            case .searchResponse(.failure(let error)):
                print(error)
                return .none
            case .searchQueryChangeDebounced:
                state.isLoading = true
                let query = state.searchQuery
                return .run { send in await send(.fetchDogs(query)) }
            case .searchQueryChanged(let query):
                if query.isEmpty {
                    state.dogs?.removeAll()
                    return .none
                } else {
                    state.searchQuery = query
                    
                    state.isLoading = true
                    let query = state.searchQuery
                    return .run { send in await send(.fetchDogs(query)) }
                }
            case .dog(id: _, action: _):
                return .none
            case .loadMoreDogs:
                state.currentPage += 1
                state.isLoadingMore = true
                let query = state.searchQuery
                return .run { send in await send(.fetchDogs(query)) }
            case .fetchDogs:
                let page = state.currentPage
                let query = state.searchQuery
                return .task {
                    await .fetchDogsResponse(
                        TaskResult { try await dogsApiClient.fetchDogs(query, page) }
                    )
                }
            case .fetchDogsResponse(.failure(let error)):
                print(error)
                return .none
            case .fetchDogsResponse(.success(let dogs)):
                state.dogs?.removeAll()
                
                let fetchedDogs = IdentifiedArrayOf<DogsSearchCellReducer.State>(
                    uniqueElements: dogs.map { dog in
                        return DogsSearchCellReducer.State(id: UUID(), dog: dog, imageURL: UserDefaults.standard.string(forKey: dog.referenceImageId ?? "") ?? "")
                    })
                
                if state.dogs != nil && state.isLoadingMore {
                    var currentDogs = state.dogs
                    currentDogs?.append(contentsOf: fetchedDogs)
                    state.dogs = currentDogs
                    state.isLoadingMore = false
                } else {
                    state.dogs = fetchedDogs
                }
                
                return .none
            case .close:
                return .none
            }
        }
    }
    
}
