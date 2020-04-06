//
//  NetworkAdapter.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 11/12/19.
//  Copyright © 2019 Soham Bhattacharjee. All rights reserved.
//

import Foundation

final class NetworkAdapter {
    
    // MARK: - Properties
    private let session: URLSession
    static let shared = NetworkAdapter(with: URLSession.shared)
    
    // MARK: - Constructor
    private init(with session: URLSession) {
        self.session = session
    }
    
    // MARK: - API Call
    /// Triggers API call with a completion call back containing the rsponse data and an Error instance
    /// - Parameters:
    ///    - request: `APIRequestProtocol` type parameter which consists of all the details required for triggering the API
    ///    - onCompletionHandler: A Completion callback containing an optional `Data` and `NetworkError` instance
    func requestAPI(with request: APIRequestProtocol, onCompletionHandler: @escaping ((_ result: Result<Data?, NetworkError>) -> Void)) {
        
        if CovidAppDelegate.appDelegateInstance?.reachability?.connection == Optional.none {
            onCompletionHandler(.failure(.internetUnavailable))
            return
        }
        
        guard let baseURL = request.baseURL?.appendingPathComponent(request.path),
            let modifiedBaseURLString = baseURL.absoluteString.removingPercentEncoding,
            let modifiedBaseURL = URL(string: modifiedBaseURLString) else {
            onCompletionHandler(.failure(.clientError))
            return
        }
                
        var urlRequest = URLRequest(url: modifiedBaseURL,
                                    cachePolicy: request.cachePolicy,
                                    timeoutInterval: request.requestTimeOutInterval)
        
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        if let requestBody = request.requestBody {
            urlRequest.httpBody = requestBody
        }
        
        for key in request.header.keys {
            urlRequest.setValue(request.header[key], forHTTPHeaderField: key)
        }
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            
            // If any error comes, return failure completion with error
            if let response = response as? HTTPURLResponse {
                if !(200..<300 ~= response.statusCode) {
                    onCompletionHandler(.failure(.getErrorType(fromErrorCode: response.statusCode)))
                    return
                }
            }
            
            if let data = data {
                onCompletionHandler(.success(data))
            } else if let error = error {
                onCompletionHandler(.failure(.customAPIError(error.localizedDescription)))
            } else {
                onCompletionHandler(.failure(.clientError))
            }
        }.resume()
    }
}
