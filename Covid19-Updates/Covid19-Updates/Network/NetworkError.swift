//
//  NetworkError.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 11/12/19.
//  Copyright © 2019 Soham Bhattacharjee. All rights reserved.
//

import Foundation

/// Defines all the network response codes. This enum also  provides a method which returns any of the `NetworkError` enum value based on the given error code. Besides, it gives you the localized error description based on  the `NetworkError` enum value.
enum NetworkError: Error {
    case unavailable
    case serverError
    case clientError
    case userExists
    case success
    case redirection
    case internetUnavailable
    case unknown
    case validationError(String)
    case customAPIError(String)
    
    /// Returns any of the `NetworkError` enum value based on the given error code
    /// - Parameters:
    ///    - errorCode: API Response Code
    /// - Returns: Any type of `NetworkError`
    static func getErrorType(fromErrorCode errorCode: Int) -> NetworkError {
        switch errorCode {
        case 100..<200: return .unavailable
        case 200..<300: return .success
        case 300..<400:
            if errorCode == 409 { return .userExists }
            return .redirection
        case 400..<500: return .clientError
        case 500..<600: return .serverError
        default: return .unknown
        }
    }
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unavailable:
            return NSLocalizedString(
                "Not Found",
                comment: ""
            )
        case .clientError:
            return NSLocalizedString(
                "Client Side Error",
                comment: ""
            )
        case .serverError:
            return NSLocalizedString(
                "Server Error",
                comment: ""
            )
        case .success:
            return NSLocalizedString(
                "Success",
                comment: ""
            )
        case .redirection:
            return NSLocalizedString(
                "Request Redirected",
                comment: ""
            )
        case .validationError(let desc), .customAPIError(let desc):
            return NSLocalizedString(
                desc,
                comment: ""
            )
        case .internetUnavailable:
            return NSLocalizedString(
                "No Internet Connection",
                comment: ""
            )
        case .userExists:
            return NSLocalizedString(
                "User already exists",
                comment: ""
            )
        case .unknown:
            return NSLocalizedString(
                "Unknown Error",
                comment: ""
            )
        }
    }
}
