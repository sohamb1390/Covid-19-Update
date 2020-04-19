//
//  CovidIndiaTrackerData.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 18/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation

struct CovidIndiaTracker: Codable {
    // MARK: Properties
    var success: Bool
    var lastRefreshDate: Date?
    var lastOriginUpdatedDate: Date?
    var data: CovidIndiaOverallData?
    
    /// Mapping Key Enum
    private enum CodingKeys: String, CodingKey {
        case success
        case data
        case lastRefreshDate = "lastRefreshed"
        case lastOriginUpdatedDate = "lastOriginUpdate"
    }
}

struct CovidIndiaOverallData: Codable {
    // MARK: Properties
    var summary: CovidIndiaSummary?
    var regionalUpdates: [CovidIndiaRegionalUpdate]?
    
    /// Mapping Key Enum
    private enum CodingKeys: String, CodingKey {
        case summary
        case regionalUpdates = "regional"
    }
}

struct CovidIndiaSummary: Codable {
    // MARK: Properties
    var totalCase: Int64?
    var confirmedInfectedIndians: Int64?
    var confirmedInfectedForeigners: Int64?
    var totalRecovered: Int64?
    var totalDeaths: Int64?
    
    /// Mapping Key Enum
    private enum CodingKeys: String, CodingKey {
        case totalCase = "total"
        case confirmedInfectedIndians = "confirmedCasesIndian"
        case confirmedInfectedForeigners = "confirmedCasesForeign"
        case totalRecovered = "discharged"
        case totalDeaths = "deaths"
    }
}

struct CovidIndiaRegionalUpdate: Codable {
    // MARK: Properties
    var locationName: String?
    var confirmedInfectedIndians: Int64?
    var confirmedInfectedForeigners: Int64?
    var totalRecovered: Int64?
    var totalDeaths: Int64?
    var totalCases: Int64?
    
    /// Mapping Key Enum
    private enum CodingKeys: String, CodingKey {
        case locationName = "loc"
        case confirmedInfectedIndians = "confirmedCasesIndian"
        case confirmedInfectedForeigners = "confirmedCasesForeign"
        case totalRecovered = "discharged"
        case totalDeaths = "deaths"
        case totalCases = "totalConfirmed"
    }
}
