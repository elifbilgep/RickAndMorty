//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 16.08.2023.
//

import UIKit

final class CharacterViewController: UIViewController, BaseViewControllerProtocol {
    
    private enum CellSize {
        static let headerHeight: Double = 30
        static let characterCellHeight: Double = 150
    }
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel: CharacterListViewViewModel
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return spinner
    }()
    
    init(viewModel: CharacterListViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        viewModel.delegate = self
        viewModel.fetchCharacters()
        
    }
    
    func configureUI() {
        configureNavBar()
        configureCollectionView()
        configureSpinner()
    }
    
    func configureNavBar() {
        setNavbar(title: TextConstant.appName)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        configureSearch()
    }
    
    func configureSearch() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    func configureSpinner() {
        
        spinner.startAnimating()
    }
    
    func configureCollectionView() {
        collectionView.frame = self.view.bounds
        
        collectionView.register(UINib(nibName: Nibs.characterCell, bundle: Bundle(for: CharacterColletionViewCell.self)), forCellWithReuseIdentifier: CharacterColletionViewCell.cellIdentifier)
        
        collectionView.register(UINib(nibName: Nibs.seasonCell, bundle: Bundle(for: SeasonSectionCell.self)), forCellWithReuseIdentifier: SeasonSectionCell.cellIdentifier)
        
        collectionView.register(FooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterLoadingCollectionReusableView.identifier)
        
        collectionView.register(UINib(nibName: Nibs.sectionHeaderCell, bundle: Bundle(for: SectionHeaderCollectionViewCell.self)), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderCollectionViewCell.cellIdentifier)

        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc private func didTapSearch() {
        let viewController = SearchViewController(config: Config(type: .character))
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
}
// MARK: - CharacterListViewViewModelDelegate
extension CharacterViewController: CharacterListViewViewModelDelegate {
    func didLoadInitialCharacters() {
        spinner.stopAnimating()
        collectionView.reloadData() // Initial fetch
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }

    // TODO:
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath]) {
        // to view model
        let sectionNumber = 1
        let newIndexPathsInSection = newIndexPaths.map { indexPath in
            return IndexPath(row: indexPath.row, section: sectionNumber)
        }
        // viewControllerdispatch
        collectionView.insertItems(at: newIndexPathsInSection)
    }
    
    func didSelectCharacter(_ character: CharacterModel) {
        let viewModel = CharacterDetailViewModel(character: character)
        let detailVC = CharacterDetailViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - CollectionView
extension CharacterViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CharacterListCaseEnum.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = CharacterListCaseEnum(rawValue: section)
        switch type {
        case .seasons:
            return 1
        case .characters:
            return viewModel.cellViewModels.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = viewModel.characters[indexPath.row]
        didSelectCharacter(character)
    }
    
    // MARK: - size for item at
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.section == 0 {
            return CGSize(width: UIScreen.screenWidth, height: CellSize.characterCellHeight)
        } else {
            return CGSize(
                // TODO:
                // Viewmodel a taşı
                width: viewModel.setCollectionCellSize(collectionView: collectionView, isHeight: false),
                height: viewModel.setCollectionCellSize(collectionView: collectionView, isHeight: true)
            )
        }
    }
    
    // MARK: - Inset for section at
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        if section == 0 {
            return UIEdgeInsets(top: .zero, left: MarginConstant.insetSmall, bottom: MarginConstant.insetSmall, right: MarginConstant.insetSmall)
        }
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // MARK: - Cell for item at
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonSectionCell.cellIdentifier, for: indexPath) as! SeasonSectionCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterColletionViewCell.cellIdentifier, for: indexPath) as! CharacterColletionViewCell
            cell.configure(with: viewModel.cellViewModels[indexPath.row])
            return cell
        }
    }
    
    // MARK: - viewForSupplementaryElementOfKind
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderCollectionViewCell.cellIdentifier, for: indexPath as IndexPath) as! SectionHeaderCollectionViewCell
            guard let type = CharacterListCaseEnum(rawValue: indexPath.section) else {
                return UICollectionReusableView()
            }
            headerView.configure(title: type.sectionTitle)
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: CellSize.headerHeight)
    }
    // MARK: - Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let offset = scrollView.contentOffset.y
           let totalContentHeight = scrollView.contentSize.height
           let totalScrollViewFixedHeight = scrollView.frame.size.height

           if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
               if let nextURLString = viewModel.apiInfo?.next, let url = URL(string: nextURLString) {
                   viewModel.fetchAdditionalCharacters(url: url)
               }
           }
       }
}
