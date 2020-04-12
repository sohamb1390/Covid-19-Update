//
//  CovidJohnHopkinsData.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 12/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation

struct CovidJohnHopkinsData: Codable {
    // MARK: Properties
    var country: String?
    var province: String?
    var updatedAt: String?
    var stats: CovidJohnHopkinsStat?
    var coordinates: CovidJohnHopkinsDataCoordinate?
    
    /// Mapping Key Enum
    private enum CodingKeys: String, CodingKey {
        case country
        case province
        case updatedAt
        case stats
        case coordinates
    }
}

struct CovidJohnHopkinsStat: Codable {
    // MARK: Properties
    var confirmed: Int64?
    var deaths: Int64?
    var recovered: Int64?
    
    /// Mapping Key Enum
    private enum CodingKeys: String, CodingKey {
        case confirmed
        case deaths
        case recovered
    }
}

struct CovidJohnHopkinsDataCoordinate: Codable {
    // MARK: Properties
    var latitude: String?
    var longitude: String?
    
    /// Mapping Key Enum
    private enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}
