//
//  MockDogsListApiClientKey.swift
//  TheDogApi
//
//  Created by Carlos Correa on 27/05/2023.
//

import Foundation
import ComposableArchitecture

extension DogsApiClient {
    
    public static let mock = Self(
        fetchDogs: mockFetchDogs,
        fetchImage: mockFetchImage)
    
    static let mockEndpointUrl = "-"
    
    static let mockFetchDogs: @Sendable (String, Int) async throws -> [Dog] =  { query, page in
        let data = ProjectConfiguration.mockData("dogs")
        
        guard let dogs = try? JSONDecoder().decode([Dog].self, from: data) else {
            fatalError("Unable to find mock response")
        }
        
        return dogs
    }
    
    static let mockFetchImage: @Sendable (String) async throws -> DogImage =  { _ in
        
        let data = ProjectConfiguration.mockData("images")
        
        guard let image = try? JSONDecoder().decode(DogImage.self, from: data) else {
            fatalError("Unable to find mock response")
        }
        
        return image
    }
    
    
}
