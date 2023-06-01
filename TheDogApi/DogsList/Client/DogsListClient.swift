//
//  DogsListClient.swift
//  TheDogApi
//
//  Created by Carlos Correa on 27/05/2023.
//

import Foundation
import ComposableArchitecture

public enum DogsApiClientError: Equatable, LocalizedError, Sendable {
    
    case decodeError
    case invalidServerResponse

    public var errorDescription: String? {
        switch self {
        case .decodeError:
            return "Something went wrong while attempting to decode the response, check the object structure."
        case .invalidServerResponse:
            return "Server appears to be down, either the resource requested no longer exists or you need to check if the request was built properly."
        }
    }
}

private enum DogsApiClientKey: TestDependencyKey {
    static let testValue = DogsApiClient.live
}

extension DogsApiClientKey: DependencyKey {
    static let liveValue = DogsApiClient.live
}

public struct DogsApiClient: Sendable {
    public var fetchDogs: @Sendable (String, Int) async throws -> [Dog]
    public var fetchImage: @Sendable (String) async throws -> DogImage
}

extension DependencyValues {
    public var dogsApiClient: DogsApiClient {
        get { self[DogsApiClientKey.self] }
        set { self[DogsApiClientKey.self] = newValue }
    }
}
