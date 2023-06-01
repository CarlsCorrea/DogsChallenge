//
//  APIClient.swift
//  TheDogApi
//
//  Created by Carlos Correa on 27/05/2023.
//

import Foundation

let jsonDecoder = JSONDecoder()

public final class APIClient: Sendable {
    
    enum SuccessStatusCode: Int, CaseIterable {
        case ok = 200
        case created = 201
        case noContents = 204
    }
    
    public static func perform<T: Decodable>(
        endpoint: String,
        as: T.Type,
        parameters: String
    ) async throws -> T {
        do {
            let url = ProjectConfiguration.baseUrl + endpoint + parameters            
            var request = URLRequest(url: URL(string: url)!)
            
            let headers: [String:String] = ["Content-Type": "application/json",
                                            "x-api-key": ProjectConfiguration.apiClientKey]
            request.addHeaders(headers)

            let (data, response) = try await URLSession.shared.data(for: request)
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

            if !isValidStatusCode(statusCode) { throw ApiError(statusCode: statusCode) }
            
            return try apiDecode(T.self, from: data)
        } catch {
            throw ApiError(error: error)
            
        }
    }
    
    private static func apiDecode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch let decodingError {
            let apiError: Error
            do {
                apiError = try jsonDecoder.decode(
                    ApiError.self,
                    from: data)
            } catch {
                throw decodingError
            }
            throw apiError
        }
    }
    
    private static func isValidStatusCode(_ statusCode: Int) -> Bool {
        return SuccessStatusCode.allCases.filter({$0.rawValue == statusCode }).count > 0
    }
    
}


extension URLRequest {
    public mutating func addHeaders(_ headers: [String:String]) {
        headers.forEach { header, value in
            addValue(value, forHTTPHeaderField: header)
        }
    }
}
