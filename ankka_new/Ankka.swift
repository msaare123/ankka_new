//
//  Ankka.swift
//  ankka_new
//  Ankka-tietotyypin esittely
//  Myös palvelimen osoite löytyy tästä tiedostosta
//  Created by Matti Saarela on 24/01/2018.
//  Copyright © 2018 Matti Saarela. All rights reserved.
//

import UIKit

let serverAddress: String = "http://192.168.1.5:8081" //Käytetty palvelin.

//Codable protocol Ankka
class Ankka: Codable {
    let id: Int
    let species: String
    let description: String
    let dateTime: Date
    let count: Int
    
    init(id: Int, species: String, description: String, dateTime: Date, count: Int){
        self.id = id
        self.species = species
        self.description = description
        self.dateTime = dateTime
        self.count = count
    }
    
    required convenience init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        let idInt:Int = Int(idString)!
        let speciesString = try container.decode(String.self, forKey: .species)
        let descString = try container.decode(String.self, forKey: .description)
        let dateTimeDate = try container.decode(Date.self , forKey: .dateTime)
        let countInt = try container.decode(Int.self, forKey: .count)
        self.init(id: idInt, species: speciesString, description: descString, dateTime: dateTimeDate, count: countInt)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case species = "species"
        case description = "description"
        case dateTime = "dateTime"
        case count = "count"
    }
}


//Codable protocol for species
class Species: Codable {
    let name: String
    
    init(name: String){
        self.name = name
    }
}
