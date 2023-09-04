//
//  SeasonSectionCell.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 22.08.2023.
//

import UIKit

class SeasonSectionCell: UICollectionViewCell {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    static let cellIdentifier = "SeasonSectionCell"
    
    private var viewModel : SeasonSectionViewModel!
    
    private enum CellSize {
        static let cellHeight : Double = 200
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewModel = SeasonSectionViewModel()
        configureUI()
    }
    
    private func configureUI(){
        configureCollectionView()
    }
    
    private func configureCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
    
        
        collectionView.register(UINib(nibName: "SeasonCell", bundle: Bundle(for: SeasonCell.self)), forCellWithReuseIdentifier: SeasonCell.cellIdentifier)
    }
    
}


extension SeasonSectionCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SeasonSectionViewModel.seasonsImageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonCell.cellIdentifier, for: indexPath) as! SeasonCell
        // Configure your season section cell here
        cell.configure(image: viewModel.imageAtIndexPath(index: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.screenWidth
        let cellWidth = screenWidth / 3.5
        
        return CGSize(width: cellWidth, height: CellSize.cellHeight ) // You can adjust the height as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: MarginConstant.inset, left: MarginConstant.inset, bottom: 0, right: MarginConstant.negativeInset)
    }
    
}
