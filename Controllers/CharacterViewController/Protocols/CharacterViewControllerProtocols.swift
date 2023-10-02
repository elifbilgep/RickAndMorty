//
//  CharacterViewControllerProtocols.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 3.10.2023.
//

import Foundation
import UIKit

protocol CharacterViewControllerProtocol {
    func configureUI()
    func didTapSearch()
}

protocol CharacterViewModelProtocol {
    var cellViewModels: [CharacterCollectionViewCellViewModel] { get set}
    var shouldShowLoadMoreIndicator: Bool { get }

    func fetchCharacters()
    func fetchAdditionalCharacters(url: URL)
    func loadMoreCharacters(with newIndexPaths: [IndexPath]) -> [IndexPath]
    func setCollectionCellSize(collectionView: UICollectionView, isHeight: Bool) -> CGFloat

}
