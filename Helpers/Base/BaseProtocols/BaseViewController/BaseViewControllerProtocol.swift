//
//  BaseViewControllerProtocol.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 4.09.2023.
//

import Foundation
import UIKit

protocol BaseViewControllerProtocol: AnyObject {
    func configureCollectionView()
}

/// any class that conforms to both BaseViewControllerProtocol and UIViewController will inherit the functionality defined within this extension.
extension BaseViewControllerProtocol where Self: UIViewController {
    
    func setBackgroundColor(_ color: UIColor = .systemBackground) {
        view?.backgroundColor = color
    }
    
    func setNavbar(title: String) {
        navigationItem.title = title
    }
}
