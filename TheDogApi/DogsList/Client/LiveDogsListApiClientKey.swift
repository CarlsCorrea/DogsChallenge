//
//  LiveDogsListApiClientKey.swift
//  TheDogApi
//
//  Created by Carlos Correa on 27/05/2023.
//

import Foundation
import ComposableArchitecture

extension DogsApiClient {
    
    public static let live = Self(
        fetchDogs: liveFetchDogs,
        fetchImage: liveFetchImage)
    
    static let liveFetchDogs: @Sendable (String, Int) async throws -> [Dog] =  { query, page in
        do {
            var parameters = ""
            if query.isEmpty {
                parameters = "?limit=10&page=\(String(page))"
            } else {
                parameters = "/search?q=\(query)".trimmingCharacters(in: .whitespacesAndNewlines)
            }
            let dogs = try await APIClient.perform(endpoint: "breeds", as: [Dog].self, parameters: parameters)
            
            if !query.isEmpty {
                for dog in dogs {
                    if let referenceImageId = dog.referenceImageId,
                       !referenceImageId.isEmpty {
                        
                        let  imgParams = "/\(referenceImageId)"
                        let image = try await APIClient.perform(endpoint: "images", as: DogImage.self, parameters: imgParams)
                        
                        // The api does not returns the image URL on search so we need to save locally
                        let defaults = UserDefaults.standard
                        defaults.set(image.url, forKey: referenceImageId)
                    }
                }
            }
            
            return dogs
        }
        catch {
            throw error
        }
    }
    
    static let liveFetchImage: @Sendable (String) async throws -> DogImage = { imageId in
        do {
            let  parameters = "/\(imageId)"
            return try await APIClient.perform(endpoint: "images", as: DogImage.self, parameters: parameters)
        }
        catch {
            throw error
        }
    }
    
}

