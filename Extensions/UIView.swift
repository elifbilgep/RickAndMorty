//
//  UIView.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 17.08.2023.
//

import UIKit
import ObjectiveC.runtime

private var keyTagIdentifier: String?

public extension UIView {
    var tagIdentifier: String? {
        get { return objc_getAssociatedObject(self, &keyTagIdentifier) as? String }
        set { objc_setAssociatedObject(self, &keyTagIdentifier, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}
