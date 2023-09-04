//
//  CharacterCell.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 16.08.2023.
//

import UIKit

final class CharacterColletionViewCell : UICollectionViewCell, BaseCollectionViewCellProtocol {
    
    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var characterNameView: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    static let cellIdentifier = "CharacterCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        characterImageView.layer.cornerRadius = 10
        characterImageView.clipsToBounds = true
        characterImageView.contentMode = .scaleAspectFill
        
        characterNameView.textColor = .label
        characterNameView.font = .systemFont(ofSize: 16,weight: .regular)

        setupLayer()
    }
    
    
    private func setupLayer(){
        stackView.layer.shadowColor = UIColor.label.cgColor
        stackView.layer.cornerRadius = 4
        stackView.layer.shadowOffset = CGSize(width: -4, height: 4)
        stackView.layer.shadowOpacity = 0.3
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupLayer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
        characterNameView.text = nil
    }
    
    func configure(with viewModel: Any?) {
        if let viewModel = viewModel as? CharacterCollectionViewCellViewModel {
            viewModel.fetchImage { [weak self] result in
                switch result{
                case .success(let data):
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self?.characterImageView.image = image
                    }
                case .failure(let error):
                    print(String(describing: error))
                    break
                }
            }
        }
    }
}
