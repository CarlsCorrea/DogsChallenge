//
//  ApiError.swift
//  TheDogApi
//
//  Created by Carlos Correa on 27/05/2023.
//

import Foundation

public struct ApiError: Codable, Error, Equatable, LocalizedError {
    
    var messageForCode: [Int: String] = [
        404: "The resource you are attempting to access no longer exists",
        400: "Unauthorized request, please make sure you have a valid session"
    ]
    
    public let errorDump: String
    public let file: String
    public let line: UInt
    public let message: String
    
    public var statusCode: Int = 0
    
    public init(statusCode: Int,
                file: StaticString = #fileID,
                line: UInt = #line) {
        
        var string = ""
        dump(statusCode, to: &string)
        self.errorDump = string
        self.file = String(describing: file)
        self.line = line
        self.statusCode = statusCode
        self.message = messageForCode[statusCode] ?? "Invalid status code"
    }
    
    public init(
        error: Error,
        file: StaticString = #fileID,
        line: UInt = #line
    ) {
        var string = ""
        dump(error, to: &string)
        self.errorDump = string
        self.file = String(describing: file)
        self.line = line
        self.message = error.localizedDescription
    }
    
    public var errorDescription: String? {
        self.message
    }
}
