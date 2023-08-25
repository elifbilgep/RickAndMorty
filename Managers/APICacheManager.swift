//
//  APICacheManager.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 20.08.2023.
//

import Foundation

/// Manages in memory session scoped API caches
final class APICacheManager{

    /// Cache map
    private var cacheDictionary : [
        Endpoint : NSCache<NSString, NSData>
    ] = [:]
    
    //Constructor
    init(){
        setupCache()
    }
    
    //MARK: - Public
    
    ///Get cached API respone
    ///endpoint: Endpoint to cache for
    ///url:  url key
    ///returns -> Nullable Data
    
    public func cachedResponse(for endpoint : Endpoint, url: URL? ) -> Data? {
        guard let targetCache = cacheDictionary[endpoint], let url = url else{
            return nil
        }
        
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    ///Set API response cache
    /// - Parameters:
    ///  - endpoint: Endpoint to cache for
    ///  - url: Url string
    ///  - data: Data to set in cache
    public func setCache(for endpoint : Endpoint, url: URL?, data : Data){
        guard let targetCache = cacheDictionary[endpoint], let url = url else{
            return
        }
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }
    
    //MARK: - Private
    
    private func setupCache(){
        Endpoint.allCases.forEach { endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        }
    }
}
