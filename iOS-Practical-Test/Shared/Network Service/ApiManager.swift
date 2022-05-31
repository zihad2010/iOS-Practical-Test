//
//  ApiManager.swift
//  iOS-Practical-Test
//
//  Created by Maya on 31/5/22.
//

import Foundation

enum BaseURL : String {
    case themoviedb = "https://api.themoviedb.org"
    case movieThumbsdb = "https://image.tmdb.org/t/p/w500/"
}

struct Api {
    static func getUrl(baseURL: BaseURL, path: String) -> URL?{
        return URL(string: baseURL.rawValue + path)
    }
}

extension URL {
    
    static let moviePath = Api.getUrl(baseURL: .themoviedb, path: "/3/search/movie")
    
    static let posterUrl: (String) -> URL? = { path in
        return Api.getUrl(baseURL: .movieThumbsdb, path: path)
    }
}

