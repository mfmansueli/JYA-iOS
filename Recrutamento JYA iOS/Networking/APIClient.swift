//
//  APIClient.swift
//  Recrutamento JYA iOS
//
//  Created by Mateus Ferneda Mansueli on 18/05/19.
//  Copyright © 2019 Mateus Ferneda Mansueli. All rights reserved.
//

import Foundation
import RxAlamofire
import Alamofire
import RxSwift

enum APIError: Error {
    case custom(reason: String)
    case noInternetConnection
    case errorDomain
    case unknown
    case connectionExpired
    case http(Error)
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .custom(let reason):
            return NSLocalizedString(reason, comment: "")
        case .noInternetConnection:
            return NSLocalizedString("Verifique sua conexão com a internet", comment: "")
        case .errorDomain:
            return NSLocalizedString("O servidor com o nome do host especificado não pôde ser encontrado", comment: "")
        case .unknown:
            return NSLocalizedString("Não foi possível identificar a causa do erro no servidor, ele pode estar temporariamente indisponível.",
                                     comment: "")
        case .connectionExpired:
            return NSLocalizedString("Tempo limite de conexão excedido",
                                     comment: "")
        case .http(let error):
            return NSLocalizedString(error.localizedDescription, comment: "")
        }
    }
}

protocol RouterType: URLRequestConvertible {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }
    var contentType: String { get }
    var paramsQueryString: [String: Any]? { get }
}

extension RouterType {
    var baseURL: URL {
        return URL(string: "https://api.github.com/repos/apple/swift/")!
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var encoding: ParameterEncoding {
        if paramsQueryString != nil {
            return URLEncoding.queryString
        }
        return JSONEncoding.default
    }
    
    var contentType: String {
        return "application/json"
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = try URLRequest(url: baseURL.appendingPathComponent(path),
                                        method: method, headers: headers)
        urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        if paramsQueryString != nil {
        urlRequest = try encoding.encode(urlRequest, with: paramsQueryString)
        }
        
        return try encoding.encode(urlRequest, with: nil)
    }
}

final class APIClient {
    private let session: SessionManager
    private let successCode: Int = 200
    
    init(session: SessionManager = SessionManager.default) {
        self.session = session
    }
    
    func requestSingle<T: Decodable>(_ route: RouterType, type: T.Type) -> Observable<T> {
        return Observable.create { observer in
            let request = self.session
                .request(route)
                .validate()
                .responseData { response in
                    self.reponseLog(response)
                    switch response.result {
                    case .success(let value):
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .formatted(.iso8601Full)
                            let result = try decoder.decode(T.self, from: value)
                            observer.onNext(result)
                            observer.onCompleted()
                        } catch {
                            observer.onError(self.onError(error, value))
                        }
                    case .failure(let error):
                        observer.onError(self.onError(error, response.data))
                    }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func requestList<T: Decodable>(_ route: RouterType, type: T.Type) -> Observable<[T]> {
        return Observable.create { observer in
            let request = self.session
                .request(route)
                .validate()
                .responseData { response in
                    self.reponseLog(response)
                    switch response.result {
                    case .success(let value):
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .formatted(.iso8601Full)
                            let result = try decoder.decode([T].self, from: value)
                            observer.onNext(result)
                            observer.onCompleted()
                        } catch {
                            observer.onError(APIError.http(error))
                        }
                    case .failure(let error):
                        observer.onError(self.onError(error, response.data))
                    }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
  
    private func reponseLog(_ response: DataResponse<Data>) {
        if let aaa = response.request, let body = aaa.httpBody {
            print("Request Parameters: \(String(describing: String(data: body, encoding: .utf8)))")
        }
        
        print("Request: \(String(describing: response.request))")
        print("Response: \(String(describing: response.response))")
        print("Error: \(String(describing: response.error))")
        
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            print("Data Parsed: \(utf8Text)")
        }
    }
    
    private func onError(_ err: Error, _ response: Data?) -> Error {
        if ((err as? DecodingError) != nil) {
            return APIError.custom(reason: "Por algum motivo, não conseguimos carregar as informações necessárias.")
        }
        
        if (err as NSError).code == NSURLErrorTimedOut
            || (err as NSError).code == NSURLErrorNetworkConnectionLost {
            return APIError.connectionExpired
        }
        
        if (err as NSError).code == NSURLErrorNotConnectedToInternet {
            return APIError.noInternetConnection
        }
        
        if (err as NSError).code == NSURLErrorCannotFindHost {
            return APIError.errorDomain
        }
        return APIError.http(err)
    }
}
