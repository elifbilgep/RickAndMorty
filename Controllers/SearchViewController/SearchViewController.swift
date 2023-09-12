//
//  SearchViewController.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 29.08.2023.
//

import UIKit

final class SearchViewController: UIViewController, BaseViewControllerProtocol {
    //MARK: - Outlets
    @IBOutlet private weak var searchBarView: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    
    //MARK: - Properties
    private let viewModel : SearchViewViewModel
    
    private var resultsViewModel: SearchResultViewModel? {
        didSet {
            self.processViewModel()
        }
    }
    
    private var collectionViewCellViewModels: [any Hashable] = []
    
    
    //MARK: - init
    //config -> type of the search
    //character, episode, location
    init(config: Config){
        let viewModel = SearchViewViewModel(config: config)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureHandlers(viewModel: viewModel)
        configureNavBar()
    }
    
    private func configureNavBar(){
        setNavbar(title: viewModel.config.type.title)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSearchBar(){
        searchBarView.delegate = self
    }
    
    @IBAction private func searchPressed(_ sender: Any) {
        executeSearch()
    }
    
}

//MARK: - Protocols
extension SearchViewController : SearchViewControllerProtocol{
    
    func executeSearch() {
        viewModel.executeSearch()
    }
    
    func processViewModel() {
        guard let resultsViewModel = resultsViewModel else {
            return
        }
        
        switch resultsViewModel.results {
        case .characters(let viewModels):
            self.collectionViewCellViewModels = viewModels
            configureCollectionView()
        //other cases can be implemented like:
        //case .location(let viewModels):
        //case .episode(let viewModels):
        }
    }
    
    func configureHandlers(viewModel : SearchViewViewModel){
        viewModel.registerSearchResultHandler { [weak self] result in
            DispatchQueue.main.async {
                self?.resultsViewModel = result
            }
        }
        
        viewModel.registerNoResultHandler {
            DispatchQueue.main.async { [weak self] in
                self?.showNoResultsAlert()
            }
        }
    }
    
    func configureCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: Nibs.characterCell, bundle: Bundle(for: CharacterColletionViewCell.self)), forCellWithReuseIdentifier: CharacterColletionViewCell.cellIdentifier)
        collectionView.reloadData()
    }
    
    func noResultSearch() {
        showNoResultsAlert()
    }
    
    //MARK: - No result Alert
    func showNoResultsAlert() {
        let alertController = UIAlertController(title: "No Results Found", message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}


//MARK: - Search Bar
extension SearchViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.set(query: searchText)
    }
}

//MARK: - collection view

extension SearchViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellViewModels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterColletionViewCell.cellIdentifier, for: indexPath)
                as? CharacterColletionViewCell else {
            fatalError()
        }
        if let characterVM = currentViewModel as? CharacterCollectionViewCellViewModel{
            cell.configure(with: characterVM)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let bounds = collectionView.bounds
        let width = UIDevice.isiPhone ? (bounds.width-30)/2 : (bounds.width-50)/4
        return CGSize(
            width: width, height: width * 1.5
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCharacter = viewModel.characterSeachResult(at: indexPath.row)
        let viewModel = CharacterDetailViewModel(character: selectedCharacter!)
        let detailVC = CharacterDetailViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

