//
//  SectionHeaderCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 22.08.2023.
//

import UIKit

class SectionHeaderCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    static let cellIdentifier = "SectionHeaderCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configure(title: String) {
        titleLabel.text = title
    }

}
