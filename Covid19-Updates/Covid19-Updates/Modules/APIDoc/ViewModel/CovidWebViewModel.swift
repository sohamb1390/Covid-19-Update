//
//  CovidWebViewModel.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 13/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation

struct CovidWebViewModel {
    // MARK: Properties
    private (set) var apiSourceWebURLString: String
    var navigationTitle: String {
        return NSLocalizedString("Covid-19 API Source", comment: "")
    }
    
    // MARK: - Constructor
    init() {
        self.apiSourceWebURLString = "https://covid-19-apis.postman.com"
    }
}
