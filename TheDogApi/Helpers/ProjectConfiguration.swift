//
//  ProjectConfiguration.swift
//  TheDogApi
//
//  Created by Carlos Correa on 27/05/2023.
//

import Foundation

class ProjectConfiguration {
    
    static var apiClientKey: String {
        get {
            if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
                if let dic = NSDictionary(contentsOfFile: path) {
                    return dic["API_CLIENT_KEY"] as? String ?? ""
                }
            }
            return ""
        }
    }
    
    static var baseUrl: String {
        get {
            if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
                if let dic = NSDictionary(contentsOfFile: path) {
                    return dic["BASE_URL"] as? String ?? ""
                }
            }
            return ""
        }
    }
    
    static func mockData(_ fileName:String) -> Data {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            fatalError("Unable to find mock data")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Unable to find mock data")
        }
        
        return data
    }

}
