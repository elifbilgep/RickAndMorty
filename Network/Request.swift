//
//  Request.swift
//  RickAndMorty
//
//  Created by Elif Bilge Parlak on 20.08.2023.
//

import Foundation

final class Request{
    
    //API constants
    private struct Constants {
        static let baseURL = "https://rickandmortyapi.com/api"
    }
    
    // desired endpoint
    let endpoint : Endpoint
    
    //Path components for PI, if any
    private let pathComponents : [String]
    
    //Query arguments for API, if any
    private let queryParameters : [URLQueryItem]
    
    private var urlString: String{
        var string = Constants.baseURL
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty{
            pathComponents.forEach {
                string += "/\($0)"
            }
        }
        
        if !queryParameters.isEmpty{
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else {return nil}
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            string += argumentString
        }
        return string
    }
    
    //Computed + constructed API url
    var url : URL?{
        return URL(string: urlString)
    }
    
    //Desired http method
    let httpMethod = "GET"
   
    ///Construct request
    /// Parameters:
    ///     - Endpoint : Target endpoint
    ///     pathComponents: Collection of path components
    ///     queryparameters: Collection of query parameters
    init(
        endpoint: Endpoint,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    ///Attempt to create request
    /// - Parameter url: URL to parse
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseURL) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseURL+"/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0] // Endpoint
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let rmEndpoint = Endpoint(
                    rawValue: endpointString
                ) {
                    self.init(endpoint: rmEndpoint, pathComponents: pathComponents)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                // value=name&value=name
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")

                    return URLQueryItem(
                        name: parts[0],
                        value: parts[1]
                    )
                })

                if let rmEndpoint = Endpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }

        return nil
    }
}

//MARK: - Request convenience

extension Request{
    static let listCharactersRequests = Request(endpoint: .character)
    static let listEpisodeRequest = Request(endpoint: .episode)
    static let listLocationsRequest = Request(endpoint: .location)
}
