//
//  Dog.swift
//  TheDogApi
//
//  Created by Carlos Correa on 27/05/2023.
//

import Foundation

public struct Dog: Identifiable, Decodable, Equatable {
    public let id: Int
    let name: String
    let origin, breedGroup: String?
    let image: DogImage?
    let referenceImageId: String?
    let temperament: String?
    
    enum CodingKeys : String, CodingKey {
        case id, name, breedGroup = "breed_group", origin, image, referenceImageId = "reference_image_id", temperament
    }
    
}
public struct DogImage: Decodable, Equatable {
    let id: String
    let url:String
}

typealias Dogs = [Dog]

extension Dog {
    static var sample = Dog(id: 1,
                            name: "Affenpinscher",
                            origin: "",
                            breedGroup: "",
                            image: DogImage(id: "BJa4kxc4X", url: "https://cdn2.thedogapi.com/images/BJa4kxc4X.jpg"),
                            referenceImageId: "",
                            temperament: ""
    )
}
