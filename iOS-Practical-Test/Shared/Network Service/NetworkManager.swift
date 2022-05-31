//
//  ApiService.swift
//  iOS-Practical-Test
//
//  Created by Maya on 31/5/22.
//

import RxSwift
import RxCocoa

enum HttpMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

struct Resource<T: Codable> {
    let url: URL
    var httpMethod: HttpMethod = .get
    var jwt: String?
    var body: Data? = nil
}

enum ApiResult<T> {
    case success(T)
    case failure(MayaApiError)
}

enum MayaApiError: Error {
    case unknownError
    case connectionError
    case invalidRequest
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
    case parsingError
    case BadRequest
    case authorizationError(Data)
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
}

extension NetworkManager {
    
     func load<T:Codable>(resource: Resource<T>) -> Observable<(ApiResult<T>)> {
        
        return Observable.just(resource.url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                
                return URLSession.shared.rx.response(request: .requestWith(resource: resource))
            }.map { response,data -> (ApiResult<T>) in
              
                switch response.statusCode {
                    
                case 200...300:
                    
                    do {
                        let data = try self.parseResponse(data: data, type: T.self)
                        return ApiResult.success(data)
                    } catch ( let error ) {
                        print("data parse:-",error)
                        print("unknown error: \(resource.url)")
                        return ApiResult.failure(.parsingError)
                    }
                case 400:
                    return ApiResult.failure(.BadRequest)
                case 401:
                    return ApiResult.failure(.authorizationError(data))
                case 402...499:
                    return ApiResult.failure(.notFound)
                case 500...599:
                    return ApiResult.failure(.serverError)
                default:
                    return .failure(.unknownError)
                }
            }
    }
    
    func parseResponse<T:Codable>(data: Data?, type: T.Type) throws -> T {
        return try JSONDecoder().decode(type.self, from: data ?? Data())
    }
}
