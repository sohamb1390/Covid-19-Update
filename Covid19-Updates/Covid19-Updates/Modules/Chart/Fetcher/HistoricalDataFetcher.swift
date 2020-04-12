//
//  HistoricalDataFetcher.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 11/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation

struct HistoricalDataFetcher {
    func getCountryWiseHistoricalData(_ onCompletion: @escaping Handler) {
        let networkAdapter = NetworkAdapter.shared
        
        networkAdapter.requestAPI(with: Covid19API.allCountriesLast30Days) { (response) in
            // Make sure we downloaded some data.
            switch response {
            case .success(let data):
                do {
                    // Make sure we downloaded some data.
                    guard let data = data else {
                        onCompletion(nil, .clientError)
                        return
                    }
                    let allCases = try JSONDecoder().decode([CountryWiseHistoricalData].self, from: data)
                    onCompletion(allCases,nil)
                } catch {
                    onCompletion(nil, .customAPIError(error.localizedDescription))
                }
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
    }
}
