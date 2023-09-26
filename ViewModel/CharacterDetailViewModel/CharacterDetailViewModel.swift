//
//  CharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 23.08.2023.
//

import UIKit

enum SectionType {
    case photo(viewModel: CharacterPhotoCollectionViewModel)
    case information(viewModels: [CharacterInfoCollectionViewCellViewModel])
}

final class CharacterDetailViewModel {

    var sections: [SectionType] = []
    private let character: CharacterModel
    private var requestURL: URL? {
        return URL(string: character.url)
    }
    
    var title: String {
        return character.name.uppercased()
    }

    // MARK: - init
    init(character: CharacterModel) {
        self.character = character
        setupSections()
    }
    
    private func setupSections() {
        sections = [
            .photo(viewModel: .init(imageURL: URL(string: character.image))),
            .information(viewModels: [
                .init(type: .status, value: character.status.text),
                .init(type: .gender, value: character.gender.rawValue),
                .init(type: .type, value: character.type),
                .init(type: .species, value: character.species),
                .init(type: .origin, value: character.origin.name),
                .init(type: .location, value: character.location.name),
                .init(type: .created, value: character.created),
                .init(type: .episodeCount, value: "\(character.episode.count)")
            ])
            
        ]
        
    }

}
