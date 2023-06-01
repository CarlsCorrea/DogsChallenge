//
//  DogsSearch.swift
//  TheDogApi
//
//  Created by Carlos Correa on 01/06/2023.
//

import SwiftUI
import ComposableArchitecture

struct DogsSearchCellReducer: ReducerProtocol {
    struct State: Equatable, Identifiable {
        var id: UUID
        var dog: Dog
        var imageURL: String = ""
    }
    
    enum Action {
        case close
    }
    
    @Dependency(\.dogsApiClient) var dogsApiClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .close:
                return .none
            }
        }
    }
}

struct DogsSearchCell: View {
    let store: StoreOf<DogsSearchCellReducer>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                AsyncImage(url: URL(string:viewStore.imageURL)) { image in
                    image
                        .resizable()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.blue.opacity(0.3))
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                
                Text(viewStore.dog.name)
            }
            
        }
        
    }
}

struct DogsSearchCell_Previews: PreviewProvider {
    static var previews: some View {
        DogsSearchCell(
            store: Store(
                initialState: DogsSearchCellReducer.State(id: UUID(), dog: Dog.sample, imageURL: ""),
                reducer: DogsSearchCellReducer()
            )
        )
    }
}
