//
//  BaseCollectionViewCellProtocol.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 4.09.2023.
//

import Foundation
import UIKit

protocol BaseCollectionViewCellProtocol : AnyObject {
    
    static var cellIdentifier: String { get }
    
    func configure(with viewModel : Any?)
    
}


