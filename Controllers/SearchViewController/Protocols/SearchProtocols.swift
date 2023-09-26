//
//  SearchProtocols.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 4.09.2023.
//

import Foundation

protocol SearchViewControllerProtocol {
    func executeSearch()
    func noResultSearch()
    func processViewModel()
    func configureHandlers(viewModel: SearchViewViewModel)
    func configureCollectionView()

    init(config: Config)
}

protocol SearchViewModelProtocol {
    var config: Config { get }
    var searchText: String { get}
    var searchResultHandler: ((SearchResultViewModel) -> Void)? {get}
    var noResultsHandler: (() -> Void)? { get }
    var searchResultModel: Codable? { get }
    
    init(config: Config)
    
    func registerSearchResultHandler(_ block: @escaping (SearchResultViewModel) -> Void)
    func registerNoResultHandler(_ block: @escaping () -> Void)
    func handleNoResults()
    func set(query text: String) 
    func executeSearch()
    func makeSearchAPICall<T: Codable>(_ type: T.Type, request: Request)
    func parseSearchResults(model: Codable)
}
