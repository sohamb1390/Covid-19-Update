//
//  CovidAllCases.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 05/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation

struct Covid19Cases: Codable {
    // MARK: Properties
    var country: String?
    var countryInfo: Covid19HitCountryInfo?
    var cases: Int64?
    var todayCases: Int64?
    var deaths: Int64?
    var todayDeaths: Int64?
    var recovered: Int64?
    var active: Int64?
    var critical: Int64?
    var casesPerOneMillion: Double?
    var deathsPerOneMillion: Double?
    var timeStamp: Int64?
    var affectedCountries: Int?
    
    /// Mapping Key Enum
    private enum CodingKeys: String, CodingKey {
        case country
        case countryInfo
        case cases
        case todayCases
        case deaths
        case todayDeaths
        case recovered
        case active
        case critical
        case casesPerOneMillion
        case deathsPerOneMillion
        case affectedCountries
        case timeStamp = "updated"
    }
}

struct Covid19HitCountryInfo: Codable {
    // MARK: Properties
    var id: Int?
    var iso2: String?
    var iso3: String?
    var latitude: Double?
    var longitude: Double?
    var flagURL: String?
    
    /// Mapping Key Enum
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case iso2
        case iso3
        case latitude = "lat"
        case longitude = "long"
        case flagURL = "flag"
    }
}
