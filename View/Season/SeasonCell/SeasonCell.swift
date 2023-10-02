//
//  SeasonCell.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 22.08.2023.
//

import UIKit

class SeasonCell: UICollectionViewCell {
    @IBOutlet private weak var seasonImageView: UIImageView!
    static let cellIdentifier = "SeasonCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(image: UIImage) {
        seasonImageView.image = image
    }
    
}
