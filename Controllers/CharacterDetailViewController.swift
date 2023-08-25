//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 23.08.2023.
//

import UIKit
import Foundation

class CharacterDetailViewController : UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var viewModel : CharacterDetailViewModel!
    
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        title = viewModel.title
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: CellFile.characterPhotoCell, bundle: Bundle(for: CharacterPhotoCollectionViewCell.self)), forCellWithReuseIdentifier: CharacterPhotoCollectionViewCell.cellIdentifer)
        collectionView.register(UINib(nibName: CellFile.characterInfoCell, bundle: Bundle(for: CharacterInfoCollectionViewCell.self)), forCellWithReuseIdentifier: CharacterInfoCollectionViewCell.cellIdentifier)
    
    }
}

//MARK: - collection view
extension CharacterDetailViewController : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .photo:
            return 1
        case .information(let viewModels):
            return viewModels.count
        }
    }
    
    //MARK: - number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        
        switch sectionType{
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterPhotoCollectionViewCell.cellIdentifer, for: indexPath) as? CharacterPhotoCollectionViewCell else{
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        case .information(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterInfoCollectionViewCell.cellIdentifier, for: indexPath) as? CharacterInfoCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .information :
            return CGSize(width: width / 2.5, height: 100)
        case .photo :
            return CGSize(width: width, height: width - 100 )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: MarginConstant.inset, bottom: 0, right: MarginConstant.inset)
    }
}
