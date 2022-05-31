//
//  URLExt.swift
//  iOS-Practical-Test
//
//  Created by Maya on 31/5/22.
//

import Foundation

extension URL {
    
    mutating func appendQueryItem(name: String, value: String?) {
    
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
    
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: name, value: value)
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        self = urlComponents.url!
    }
}
