//
//  SeasonSectionViewModel.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 22.08.2023.
//

import UIKit

final class SeasonSectionViewModel{
    
    static let seasonsImageNames : [String] = ["0-rm","1-rm","2-rm","3-rm","4-rm","5-rm","6-rm","7-rm","8-rm","9-rm"]
    
    func imageAtIndexPath(index: IndexPath) -> UIImage {
        if let image = UIImage(named: SeasonSectionViewModel.seasonsImageNames[index.row]) {
            return image
        }
        return UIImage(named: "0-rm")!
    }
}
