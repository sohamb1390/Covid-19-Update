//
//  CoovidDashboardFetcher.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 05/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation

struct CoovidDashboardFetcher {
    func getTotalCases(_ onCompletion: @escaping Handler) {
        let networkAdapter = NetworkAdapter.shared
        
        networkAdapter.requestAPI(with: Covid19API.allCases) { (response) in
            // Make sure we downloaded some data.
            switch response {
            case .success(let data):
                do {
                    // Make sure we downloaded some data.
                    guard let data = data else {
                        onCompletion(nil, .clientError)
                        return
                    }
                    let allCases = try JSONDecoder().decode(Covid19Cases.self, from: data)
                    onCompletion(allCases,nil)
                } catch {
                    onCompletion(nil, .customAPIError(error.localizedDescription))
                }
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
    }
    
    func getCountryWiseData(_ onCompletion: @escaping Handler) {
        let networkAdapter = NetworkAdapter.shared
        
        networkAdapter.requestAPI(with: Covid19API.hitCountries) { (response) in
            // Make sure we downloaded some data.
            switch response {
            case .success(let data):
                do {
                    // Make sure we downloaded some data.
                    guard let data = data else {
                        onCompletion(nil, .clientError)
                        return
                    }
                    let allCases = try JSONDecoder().decode([Covid19Cases].self, from: data)
                    onCompletion(allCases,nil)
                } catch {
                    onCompletion(nil, .customAPIError(error.localizedDescription))
                }
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
    }
    
    func getJohnHopkinsCountryWiseData(_ onCompletion: @escaping Handler) {
        let networkAdapter = NetworkAdapter.shared
        
        networkAdapter.requestAPI(with: Covid19API.johnHopkins) { (response) in
            // Make sure we downloaded some data.
            switch response {
            case .success(let data):
                do {
                    // Make sure we downloaded some data.
                    guard let data = data else {
                        onCompletion(nil, .clientError)
                        return
                    }
                    let allCases = try JSONDecoder().decode([CovidJohnHopkinsData].self, from: data)
                    onCompletion(allCases,nil)
                } catch {
                    onCompletion(nil, .customAPIError(error.localizedDescription))
                }
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
    }
    
    func downloadFlagIcon(from urlString: String, _ onComplete: @escaping ((_ data: Data?, _ error: NetworkError?) -> Void)) {
        guard let url = URL(string: urlString) else {
            onComplete(nil, .clientError)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                onComplete(nil, .customAPIError(error.localizedDescription))
            } else if let data = data {
                onComplete(data, nil)
            } else {
                onComplete(nil, .clientError)
            }
        }.resume()
    }
}
