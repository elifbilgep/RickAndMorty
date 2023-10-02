//
//  CharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 23.08.2023.
//

import UIKit

final class CharacterInfoCollectionViewCellViewModel {
    
    private let type: `Type`
    private let value: String
    
    init(type: Type, value: String) {
        self.type = type
        self.value = value
    }

    enum `Type`: String {
        case status
        case gender
        case type
        case species
        case origin
        case created
        case location
        case episodeCount

        var tintColor: UIColor {
            switch self {
            case .status:
                return .systemBlue
            case .gender:
                return .systemRed
            case .type:
                return .systemPurple
            case .species:
                return .systemGreen
            case .origin:
                return .systemOrange
            case .created:
                return .systemPink
            case .location:
                return .systemYellow
            case .episodeCount:
                return .systemMint
            }
        }
        var displayTitle: String {
            switch self {
            case .status,
                .gender,
                .type,
                .species,
                .origin,
                .created,
                .location:
                return rawValue.uppercased()
            case .episodeCount:
                return "EPISODE COUNT"
            }
        }
    }

    var title: String {
        return type.displayTitle
    }
    
    var tintColor: UIColor {
        return type.tintColor
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter
    }()
    
    var displayValue: String {
        if value.isEmpty {
            return "None"
        }
        if let date = Self.dateFormatter.date(from: value),
           type == .created {
            return Self.shortDateFormatter.string(from: date)
        }
        return value
    }
}
