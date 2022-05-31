//
//  URLRequestExt.swift
//  iOS-Practical-Test
//
//  Created by Maya on 31/5/22.
//

import Foundation

extension URLRequest {
    
    static func requestWith<T:Decodable>(resource:Resource<T>)-> URLRequest{
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        return request
    }
}

enum HTTPHeaderField: String {
    case authentication  = "Authorization"
    case contentType     = "Content-Type"
    case acceptType      = "Accept"
    case acceptEncoding  = "Accept-Encoding"
    case acceptLangauge  = "Accept-Language"
    case accessToken  =  "access-token"
    case apikey  =  "api-key"
    case src  =  "src"
    case appVersion  =  "app-version"
}

enum ContentType: String {
    case json            = "application/json"
    case multipart       = "multipart/form-data"
    case ENUS            = "en-us"
}

