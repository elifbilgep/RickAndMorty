//
//  CharacterInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 23.08.2023.
//

import UIKit

class CharacterInfoCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "CharacterInfoCollectionViewCell"
    
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var valueTitle: UILabel!
 

    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleView.backgroundColor = .secondarySystemBackground
    }
    

    override func prepareForReuse() {
        title.text = nil
        valueTitle.text = nil
    }
    
    func configure(with viewModel: CharacterInfoCollectionViewCellViewModel){
        valueTitle.text = viewModel.displayValue
        title.text = viewModel.title
        title.textColor = viewModel.tintColor
    }
}
