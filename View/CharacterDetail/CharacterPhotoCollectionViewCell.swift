//
//  CharacterPhotoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 23.08.2023.
//

import UIKit

class CharacterPhotoCollectionViewCell: UICollectionViewCell, BaseCollectionViewCellProtocol {
    
    @IBOutlet private weak var characterImageView: UIImageView!
    
    static let cellIdentifier = "CharacterPhotoCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        characterImageView.contentMode = .scaleAspectFill
        characterImageView.layer.cornerRadius = 20
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
    }
    
    func configure(with viewModel: Any?) {
        if let viewModel = viewModel as? CharacterPhotoCollectionViewModel{
            viewModel.fetchImage { [weak self] result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.characterImageView.image = UIImage(data: data)
                    }
                case .failure:
                    break
                }
            }
        }
    }
}
