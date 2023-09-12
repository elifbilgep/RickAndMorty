//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 23.08.2023.
//

import UIKit

final class CharacterDetailViewController : UIViewController, BaseViewControllerProtocol {
    
    @IBOutlet private weak var collectionView: UICollectionView!
        
    private let viewModel : CharacterDetailViewModel
    
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    init(viewModel : CharacterDetailViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI(){
        configureCollectionView()
        initializeCollectionView()
        configureSpinner()
        configureTabBar()
    }
    
    private func configureTabBar(){
        setNavbar(title: viewModel.title)
    }

    private func configureSpinner(){
        spinner.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: Nibs.characterPhotoCell, bundle: Bundle(for: CharacterPhotoCollectionViewCell.self)), forCellWithReuseIdentifier: CharacterPhotoCollectionViewCell.cellIdentifier)
        collectionView.register(UINib(nibName: Nibs.characterInfoCell, bundle: Bundle(for: CharacterInfoCollectionViewCell.self)), forCellWithReuseIdentifier: CharacterInfoCollectionViewCell.cellIdentifier)
    }
    
    private func initializeCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.frame = self.view.bounds
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
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
            return viewModels.count        }
    }
    
    //MARK: - number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        
        switch sectionType{
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterPhotoCollectionViewCell.cellIdentifier, for: indexPath) as? CharacterPhotoCollectionViewCell else{
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
        let width = UIScreen.screenWidth
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .information :
            return CGSize(width: width / 2.5, height: 100)// TO VİEWMODEL
        case .photo :
            return CGSize(width: width, height: width - 100 )
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: .zero, left: MarginConstant.insetMeduim, bottom: .zero, right: MarginConstant.insetMeduim)
    }
}
