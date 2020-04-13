//
//  APIConstants.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 08/01/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation

/// HTTP Methods
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

/// Detourz Service URLs
struct Covid19Service {
    static let baseURL = "https://corona.lmao.ninja"
}

/// API path Enum
enum Covid19API {
    case allCases
    case hitCountries
    case countryFilter(country: String)
    // Returning Invalid Data
    // case johnHopkins
    case unitedStatesData
    case allCountriesLast30Days
}

extension Covid19API: APIRequestProtocol {
    var baseURL: URL? {
        return URL(string: Covid19Service.baseURL)
    }
    
    var requestBody: Data? {
        return nil
    }
    
    var header: HTTPHeaders {
        let header = ["Content-Type": "application/json"]
        return header
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        return URLRequest.CachePolicy.reloadIgnoringCacheData
    }
    
    var requestTimeOutInterval: TimeInterval {
        return 30.0
    }

    var path: String {
        switch self {
        case .allCases:
            return "/all"
        case .hitCountries:
            return "/countries?sort=country"
        case .countryFilter(let country):
            return "/countries/\(country)"
        // Returning Invalid Data
        // case .johnHopkins:
            // return "/v2/jhucsse"
        case .unitedStatesData:
            return "/states"
        case .allCountriesLast30Days:
            return "/v2/historical?lastdays=30"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .allCases,
             .hitCountries,
             .countryFilter,
             // Returning Invalid Data
             // .johnHopkins,
             .unitedStatesData,
             .allCountriesLast30Days: return .GET
        }
    }
}
