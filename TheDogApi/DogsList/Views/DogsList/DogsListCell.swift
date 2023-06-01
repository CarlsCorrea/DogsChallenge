//
//  DogsListCellView.swift
//  TheDogApi
//
//  Created by Carlos Correa on 28/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct DogsListCellReducer: ReducerProtocol {
    struct State: Equatable, Identifiable {
        var id: UUID
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

struct DogsListCell: View {
    let store: StoreOf<DogsListCellReducer>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                AsyncImage(url: URL(string:viewStore.dog.image?.url ?? "")) { image in
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

struct DogsListCellView_Previews: PreviewProvider {
    static var previews: some View {
        DogsListCell(
            store: Store(
                initialState: DogsListCellReducer.State(id: UUID(), dog: Dog.sample),
                reducer: DogsListCellReducer()
            )
        )
    }
}
