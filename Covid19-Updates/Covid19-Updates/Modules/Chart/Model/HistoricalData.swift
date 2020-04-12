//
//  HistoricalData.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 11/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation

struct CountryWiseHistoricalData: Codable {
    // MARK: Properties
    var country: String?
    var province: String?
    var timeline: HistoricalData?
    
    /// Mapping Key Enum
    private enum CodingKeys: String, CodingKey {
        case country
        case province
        case timeline
    }
}

struct HistoricalData: Codable {
    // MARK: Properties
    var cases: [String: Int64]?
    var deaths: [String: Int64]?
    var recovered: [String: Int64]?
    
    /// Mapping Key Enum
    private enum CodingKeys: String, CodingKey {
        case cases
        case deaths
        case recovered
    }
}
