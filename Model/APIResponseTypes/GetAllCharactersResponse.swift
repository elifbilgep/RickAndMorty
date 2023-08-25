//
//  GetAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 20.08.2023.
//

import Foundation

struct GetAllCharactersResponse : Codable{
    
    struct Info : Codable{
        let count: Int
        let pages: Int
        let next: String?
        let prv: String?
        
    }
    
    let info: Info
    let results: [CharacterModel]
}
