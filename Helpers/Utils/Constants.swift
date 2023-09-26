//
//  TextConstants.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 25.08.2023.
//

import Foundation

struct TextConstant {
    static let appName = "Rick And Morty"
}

struct Nibs {
    static let characterCell = "CharacterCell"
    static let seasonCell = "SeasonSectionCell"
    static let sectionHeaderCell = "SectionHeaderCollectionViewCell"
    static let characterPhotoCell = "CharacterPhotoCollectionViewCell"
    static let characterInfoCell = "CharacterInfoCollectionViewCell"
}

struct Segue {
    static let characterDetailSegue = "CharacterDetailViewControllerSegue"
    
}

struct MarginConstant {
    static let insetLarge: CGFloat = 20.0
    static let insetMeduim: CGFloat = 15.0
    static let insetSmall: CGFloat = 10.0

}

struct Config {
    enum ConfigType {
        case character
        case episode
        case location
        
        var endpoint: Endpoint {
            switch self {
            case .character: return .character
            case .episode: return .episode
            case .location: return .location
            }
        }
        
        var title: String {
            switch self {
            case .character:
                return "Search Characters"
            case .location:
                return "Search Location"
            case .episode:
                return "Search Episode"
            }
        }
    }
    
    let type: ConfigType
}
