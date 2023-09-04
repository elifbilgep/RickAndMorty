//
//  SearchViewController.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 29.08.2023.
//

import UIKit

final class SearchViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var searchBarView: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: - Properties
    private let viewModel : SearchViewViewModel
    
    private var resultsViewModel: SearchResultViewModel? {
        didSet {
            self.processViewModel()
        }
    }
    
    private var collectionViewCellViewModels: [any Hashable] = []
    
    
    struct Config{
        enum ConfigType {
            case character
            case episode
            case location
            
            var endpoint : Endpoint{
                switch self {
                case .character : return .character
                case .episode : return .episode
                case .location : return .location
                }
            }
            
            var title: String {
                switch self{
                case .character:
                    return "Search Characters"
                case .location:
                    return "Search Location"
                case .episode:
                    return "Search Episode"
                }
            }
        }
        
        let type : ConfigType
    }
    
    
    //MARK: - init
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
        view.backgroundColor = .systemBackground
        configureSearchBar()
        configureHandlers(viewModel: viewModel)
        
    }
    
    private func configureSearchBar(){
        searchBarView.delegate = self
    }
    
    private func configureHandlers(viewModel : SearchViewViewModel){
        viewModel.registerSearchResultHandler { [weak self] result in
            DispatchQueue.main.async {
                self?.resultsViewModel = result
            }
        }
        
        viewModel.registerNoResultHandler {
            DispatchQueue.main.async {
                self.showNoResultsAlert()
            }
        }
    }
    
    func showNoResultsAlert() {
        let alertController = UIAlertController(title: "No Results Found", message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func searchPressed(_ sender: Any) {
        viewModel.executeSearch()
    }
    
    private func processViewModel() {
        guard let resultsViewModel = resultsViewModel else {
            return
        }
        
        switch resultsViewModel.results {
        case .characters(let viewModels):
            self.collectionViewCellViewModels = viewModels
            setUpCollectionView()
            //other cases can be implemented
        }
    }
    
    func setUpCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: Nibs.characterCell, bundle: Bundle(for: CharacterColletionViewCell.self)), forCellWithReuseIdentifier: CharacterColletionViewCell.cellIdentifier)
        collectionView.reloadData()
    }
}


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
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
