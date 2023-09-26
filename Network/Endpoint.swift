//
//  EndPoint.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 20.08.2023.
//

import Foundation

@frozen enum Endpoint: String, CaseIterable, Hashable {
    // endpoint to get character info
    case character
    // endpoint to get location info
    case location
    // endpoint to get epsode info
    case episode
}
