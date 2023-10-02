//
//  CharacterStatusModel.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 20.08.2023.
//

import Foundation

enum CharacterStatusModel: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case `unknown` = "unknown"
 
    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unkown"
        }
    }
}
