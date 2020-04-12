//
//  CovidSharedData.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 07/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation

final class CovidSharedData {
    // MARK: Properties
    var countryWiseCases: [Covid19Cases] = []
    var johnHopkinsCountryWiseCase: [CovidJohnHopkinsData] = []
    static let shared = CovidSharedData()
    
    // MARK: - COnstructor
    private init() {
    }
}
