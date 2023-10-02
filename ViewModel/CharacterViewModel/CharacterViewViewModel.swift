    //
    //  CharacterListViewModel.swift
    //  RickAndMorty
    //
    //  Created by Elif Bilge Parlak on 20.08.2023.
    //

    import UIKit

    protocol CharacterViewViewModelDelegate: AnyObject {
        func didLoadInitialCharacters()
        func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
        func didSelectCharacter(_ character: CharacterModel)
    }

    enum CharacterListCaseEnum: Int, CaseIterable {
        case seasons = 0
        case characters

        var sectionTitle: String {
            switch self {
            case .seasons:
                return "Seasons"
            case .characters:
                return "Characters"
            }
        }
    }

final class CharacterViewViewModel: NSObject {

    weak var delegate: CharacterViewViewModelDelegate?

    var isLoadingMoreCharacters = false
    var apiInfo: GetAllCharactersResponse.Info?

    var cellViewModels: [CharacterCollectionViewCellViewModel] = []

    // bunu better la
    var characters: [CharacterModel] = [] {
        didSet {
            for character in characters {
                let viewModel = CharacterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImageUrl: URL(string: character.image))
                print(viewModel.characterName)
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }

}
extension CharacterViewViewModel: CharacterViewModelProtocol {

    // Fetch initial set of characters (20)
    func fetchCharacters() {
        Service.shared.execute(.listCharactersRequests, expecting: GetAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.characters = results
                self?.apiInfo = info

                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }

    // Paginate if additional characters are needed
    func fetchAdditionalCharacters(url: URL) {
           guard !isLoadingMoreCharacters else {
               return
           }
           isLoadingMoreCharacters = true
           guard let request = Request(url: url) else {
               isLoadingMoreCharacters = false
               return
           }

           Service.shared.execute(request, expecting: GetAllCharactersResponse.self) { [weak self] result in
               guard let self else {
                   return
               }

               switch result {
               case .success(let responseModel):
                   let moreResults = responseModel.results
                   let info = responseModel.info
                   self.apiInfo = info

                   let originalCount = self.characters.count
                   let newCount = moreResults.count
                   let total = originalCount + newCount
                   let startingIndex = total - newCount
                   let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap({
                       return IndexPath(row: $0, section: 0)
                   })
                   self.characters.append(contentsOf: moreResults)
                   DispatchQueue.main.async {
                       self.delegate?.didLoadMoreCharacters(with: indexPathsToAdd)
                       self.isLoadingMoreCharacters = false
                   }
               case .failure(let error):
                   print(String(describing: error))
                   self.isLoadingMoreCharacters = false
               }

           }
    }

    func loadMoreCharacters(with newIndexPaths: [IndexPath]) -> [IndexPath] {
        let sectionNumber = 1
        let newIndexPathsInSection = newIndexPaths.map { indexPath in
            return IndexPath(row: indexPath.row, section: sectionNumber)
        }
        return newIndexPathsInSection
    }

    var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }

    func setCollectionCellSize(collectionView: UICollectionView, isHeight: Bool) -> CGFloat {

        let bounds = collectionView.bounds
        let width: CGFloat

        width = (bounds.width - 30) / 2.1
        if isHeight {
            return width * 1.5
        } else {
            return width
        }
    }
}
