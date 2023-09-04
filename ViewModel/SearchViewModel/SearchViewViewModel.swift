//
//  SearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 29.08.2023.
//

import Foundation

final class SearchViewViewModel {
    
    let config : SearchViewController.Config
    
    private var searchText = ""
    
    private var searchResultHandler : ((SearchResultViewModel)-> Void)?
    
    private var noResultsHandler : (()-> Void)?
    
    private var searchResultModel : Codable?
    
    //MARK: - init
    
    init(config: SearchViewController.Config){
        self.config = config
    }
    
    //MARK: - Public
    
    //Results callback
    func registerSearchResultHandler(_ block: @escaping (SearchResultViewModel) -> Void){
        self.searchResultHandler = block
    }
    
    //MARK: - No Results Callback
    func registerNoResultHandler(_ block: @escaping ()-> Void){
        self.noResultsHandler = block
    }
    
    func executeSearch() {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        
        //Building arguments
        let queryParams : [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
        
        //Add options
        //Later
        
        //Create request
        let request = Request(endpoint: config.type.endpoint,
        queryParameters: queryParams)
        
        switch config.type.endpoint {
        case .character:
            makeSearchAPICall(GetAllCharactersResponse.self,request: request)
        
        case .location: break
            //later
        case .episode: break
            //later
        }
    }
    
     private func makeSearchAPICall<T : Codable>(_ type: T.Type, request: Request){
        Service.shared.execute(request, expecting: type) { [weak self] result in
            //notify view of results no results or error
            
            switch result {
            case .success(let model):
                self?.processSearchResults(model: model)
            case .failure:
                self?.handleNoResults()
                break
            }
        }
    }
    
    private func processSearchResults(model : Codable){
        var resultsVM : SearchResultType?
        var nextURL : String?
        
        if let characterResults = model as? GetAllCharactersResponse {
            resultsVM = .characters(characterResults.results.compactMap({
                print($0.name)
                return CharacterCollectionViewCellViewModel(characterName: $0.name, characterStatus:  $0.status, characterImageUrl:  URL(string:  $0.image))
            }))
            nextURL = characterResults.info.next
        }
        if let results = resultsVM{
            self.searchResultModel = model
            let vm = SearchResultViewModel(results: results, next: nextURL)
            self.searchResultHandler?(vm)
        } else{
            handleNoResults()
        }
    }
    
    private func handleNoResults(){
        noResultsHandler?()
    }
    
    func set(query text: String){
        self.searchText = text
    }
    
    func characterSeachResult(at index: Int)-> CharacterModel?{
        guard let searchModel = searchResultModel as? GetAllCharactersResponse else{
            return nil
        }
        
        return searchModel.results[index]
    }
}
