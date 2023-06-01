//
//  ContentView.swift
//  TheDogApi
//
//  Created by Carlos Correa on 27/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    @State public var selectedTab = 0
    
    var body: some View {
        
        TabView(
            selection: $selectedTab
        ) {
            DogsView(
                store: Store(
                    initialState: DogsReducer.State(dogs: []),
                    reducer: DogsReducer()
                )
            )
            .tabItem {
                Text("Dogs")
            }
            .tag(selectedTab)
            
            DogsSearchView(
                store: Store(
                    initialState: DogsSearchReducer.State(dogs: []),
                    reducer: DogsSearchReducer()
                )
            )
            .tabItem {
                Text("Search Dogs")
            }
            .tag(selectedTab)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
