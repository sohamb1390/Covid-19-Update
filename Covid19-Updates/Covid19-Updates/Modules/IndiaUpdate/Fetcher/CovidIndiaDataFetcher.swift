//
//  CovidIndiaDataFetcher.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 18/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation

struct CovidIndiaDataFetcher {
    func getIndiaCases(_ onCompletion: @escaping Handler) {
        let networkAdapter = NetworkAdapter.shared
        
        networkAdapter.requestAPI(with: Covid19API.indiaData) { (response) in
            // Make sure we downloaded some data.
            switch response {
            case .success(let data):
                do {
                    // Make sure we downloaded some data.
                    guard let data = data else {
                        onCompletion(nil, .clientError)
                        return
                    }
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                    let indiaData = try decoder.decode(CovidIndiaTracker.self, from: data)
                    onCompletion(indiaData,nil)
                } catch {
                    onCompletion(nil, .customAPIError(error.localizedDescription))
                }
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
    }
}
