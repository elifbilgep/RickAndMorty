//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 16.08.2023.
//

import UIKit

final class CharacterViewController: UIViewController,CharacterListViewViewModelDelegate {
    
    private enum Sections : String{
        case Seasons, Characters
    }
    
    private enum CellSize{
        static let headerHeight : Double = 30
        static let characterCellHeight : Double = 150
    }
    //MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var viewModel: CharacterListViewViewModel!//kaçın -
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        self.view.addSubview(collectionView)
        collectionView.frame = self.view.bounds
        //nav fonskşyonu> configure ui() -> tüm view itemların işlemleri
        
        //add navbar
        title = TextConstant.appName
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        viewModel = CharacterListViewViewModel()
        view.addSubview(spinner)
        
        viewModel.delegate = self
        
        initSpinner()
        
        configureCollectionView()
        viewModel.fetchCharacters()
        
    }
    
    //conf nav bar ()
    
    //conf ui -> configures
    
    func configureCollectionView(){
        collectionView.register(UINib(nibName: CellFile.characterCell, bundle: Bundle(for: CharacterColletionViewCell.self)), forCellWithReuseIdentifier: CharacterColletionViewCell.cellIdentifier)
        
        collectionView.register(UINib(nibName: CellFile.seasonCell, bundle: Bundle(for: SeasonSectionCell.self)), forCellWithReuseIdentifier: SeasonSectionCell.cellIdentifier)
        
        collectionView.register(FooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterLoadingCollectionReusableView.identifier)
        
        collectionView.register(UINib(nibName: CellFile.sectionHeaderCell, bundle: Bundle(for: SectionHeaderCollectionViewCell.self)), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderCollectionViewCell.cellIdentifier)
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    func initSpinner(){
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.startAnimating()
    }
    
    func didLoadInitialCharacters() {
        spinner.stopAnimating()
        collectionView.reloadData() // Initial fetch
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
        
    }
    
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath]) {
        let sectionNumber = 1 // Specify the section number where you want to insert items
        let newIndexPathsInSection = newIndexPaths.map { indexPath in
            return IndexPath(row: indexPath.row, section: sectionNumber)
        }
        collectionView.insertItems(at: newIndexPathsInSection)
    }
    
    func didSelectCharacter(_ character: CharacterModel) {
        let viewModel = CharacterDetailViewModel(character: character)
        let detailVC = CharacterDetailViewController(viewModel: viewModel)
        print(viewModel.sections)
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    //MARK: - CollectionView
}

extension CharacterViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return  viewModel.cellViewModels.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let character = viewModel.characters[indexPath.row]
        didSelectCharacter(character)
    }
    
    //MARK: - size for item at
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let bounds = collectionView.bounds
        let width: CGFloat
        let screenWidth = UIScreen.main.bounds.width
        
        
        width = (bounds.width - 30) / 2.2//view model a
        
        if indexPath.section == 0 {
            return CGSize(width: screenWidth,height: CellSize.characterCellHeight)
        }else{
            return CGSize(//Viewmodel a taşı
                width: width,
                height: width * 1.5
            )
        }
    }
    
    //MARK: - Inset for section at
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsets(top: MarginConstant.inset, left: MarginConstant.inset, bottom: MarginConstant.inset, right: MarginConstant.inset)
    }
    
    //MARK: - Cell for item at
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonSectionCell.cellIdentifier, for: indexPath) as! SeasonSectionCell
            // Configure your season section cell here
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterColletionViewCell.cellIdentifier, for: indexPath) as! CharacterColletionViewCell
            cell.configure(with: viewModel.cellViewModels[indexPath.row])
            return cell
        }
    }
    
    //MARK: - viewForSupplementaryElementOfKind
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderCollectionViewCell.cellIdentifier, for: indexPath as IndexPath) as! SectionHeaderCollectionViewCell
            
            if indexPath.section == 0{
                headerView.configure(title: Sections.Seasons.rawValue)
            }else{
                headerView.configure(title:  Sections.Seasons.rawValue)
            }
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: CellSize.headerHeight)
    }
    //MARK: - Scroll
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
