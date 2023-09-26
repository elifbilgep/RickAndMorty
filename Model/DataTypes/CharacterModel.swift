//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 20.08.2023.
//

import Foundation

struct CharacterModel: Codable {
    
    let id: Int
    let name: String
    let status: CharacterStatusModel
    let species: String
    let type: String
    let gender: CharacterGenderModel
    let origin: RMOrigin
    let location: SingleLocationModel
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
}
