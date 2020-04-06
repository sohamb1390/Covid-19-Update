//
//  NetworkProtocol.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 13/12/19.
//  Copyright © 2019 Soham Bhattacharjee. All rights reserved.
//

import Foundation

typealias HTTPHeaders = [String: String]

protocol APIRequestProtocol {
    /// Base URL
    var baseURL: URL? { get }
    /// API Request Path
    var path: String { get }
    /// HTTP Method i.e `GET/POST/PUT/DELETE` to be used for invoking any API call
    var httpMethod: HTTPMethod { get }
    /// Request Data which is required for `POST/PUT `call i.e for adding or updating a contact
    var requestBody: Data? { get }
    /// HTTP Header
    var header: HTTPHeaders { get }
    /// Network Cache Policy
    var cachePolicy: URLRequest.CachePolicy { get }
    /// Timeout intervak
    var requestTimeOutInterval: TimeInterval { get }
}
