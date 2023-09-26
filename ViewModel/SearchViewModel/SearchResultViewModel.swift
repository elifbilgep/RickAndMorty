//
//  SearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 29.08.2023.
//

import Foundation

final class SearchResultViewModel {
    
    private(set) var results: SearchResultType
    
    private var next: String?
    
    init(results: SearchResultType, next: String?) {
        self.results = results
        self.next = next
    }
    
    private (set) var isLoadingMoreResults = false
    
    var shouldShowLoadMoreIndicator: Bool {
        return next != nil // next nil ise false
    }
    
    func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void) {

        guard !isLoadingMoreResults else {
            return
        }
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        isLoadingMoreResults = true
        
        guard let request = Request(url: url) else {
            isLoadingMoreResults = false
            return
        }
        
        switch results {
        case .characters(let existingResults):
            Service.shared.execute(request, expecting: GetAllCharactersResponse.self) { [weak self] result in
                guard let self else {
                    return
                }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    self.next = info.next// get new pagination url
                    
                    let additionalResults = moreResults.compactMap({
                        return CharacterCollectionViewCellViewModel(characterName: $0.name, characterStatus: $0.status, characterImageUrl: URL(string: $0.image))
                    })
                    
                    var newResults: [CharacterCollectionViewCellViewModel] = []
                    newResults = existingResults + additionalResults
                    self.results = .characters(newResults)
                    DispatchQueue.main.async {
                        self.isLoadingMoreResults = false
                        
                        completion(newResults)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.isLoadingMoreResults = false
                }
            }
        }
    }
}

enum SearchResultType {
    case characters([CharacterCollectionViewCellViewModel])
    // can be extended later
}
