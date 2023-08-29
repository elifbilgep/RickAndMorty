//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 20.08.2023.
//

import UIKit

protocol CharacterListViewViewModelDelegate : AnyObject{
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    func didSelectCharacter(_ character: CharacterModel)
}

final class CharacterListViewViewModel : NSObject{
    
    weak var delegate: CharacterListViewViewModelDelegate?
    
    var isLoadingMoreCharacters = false
    var apiInfo : GetAllCharactersResponse.Info? = nil
    
    //bunu better la
    var characters : [CharacterModel] = [] {
        didSet{
            for character in characters{
                let viewModel = CharacterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImageUrl: URL(string: character.image))
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
                
            }
            
        }
    }
    
    var cellViewModels : [CharacterCollectionViewCellViewModel] = []
    
    
    //Fetch initial set of characters (20)
    public func fetchCharacters(){
        Service.shared.execute(.listCharactersRequests, expecting: GetAllCharactersResponse.self) { [weak self] result in
            switch result{
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
    public func fetchAdditionalCharacters(url : URL){
        guard !isLoadingMoreCharacters else{
            return
        }
        isLoadingMoreCharacters = true
        guard let request = Request(url: url) else{
            isLoadingMoreCharacters = false
            return
        }
        
        Service.shared.execute(request, expecting: GetAllCharactersResponse.self) { [weak self] result in
            guard let self else{
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
                let indexPathsToAdd : [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap({
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
    
    var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

