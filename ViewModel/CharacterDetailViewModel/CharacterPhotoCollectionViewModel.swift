//
//  CharacterPhotoCollectionViewModel.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 23.08.2023.
//

import Foundation

final class CharacterPhotoCollectionViewModel {
    
    private let imageURL: URL?
    
    init(imageURL: URL?) {
        self.imageURL = imageURL
    }
    
    func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageUrl = imageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        ImageLoader.shared.downloadImage(imageUrl, completion: completion)
    }
}
