//
//  CovidCountryListViewModel.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 12/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation
import UIKit

final class CovidCountryListViewModel: NSObject {
    // MARK: Properties
    private var countryDetails: [String: UIImage?] = [:]
    private var filteredCountryDetails: [String: UIImage?] = [:]
    private (set) var selectedCountryName: Observable<String> = Observable()
    private (set) var shouldReload: Observable<Bool> = Observable(true)
    var searchbarPlaceholder: String {
        return NSLocalizedString("Try searching using Country/Province names", comment: "")
    }
    var navigationBarTitle: String {
        return NSLocalizedString("Affected Countries/Provinces", comment: "")
    }
    
    // MARK: - Constructor
    init(with countryDetails: [String: UIImage?], selectedCountryName: String) {
        self.countryDetails = countryDetails
        self.filteredCountryDetails = countryDetails
        self.selectedCountryName.value = selectedCountryName
    }
    
    // MARK: - Datasource
    func numberOfRows() -> Int {
        return filteredCountryDetails.keys.count
    }
    
    func details(at indexPath: IndexPath) -> (name: String, image: UIImage?, isSelected: Bool)? {
        if filteredCountryDetails.keys.count > indexPath.row {
            let key = Array(filteredCountryDetails.keys)[indexPath.row]
            if let image = filteredCountryDetails[key] {
                return (name: key, image: image, isSelected: key == selectedCountryName.value)
            }
        }
        return nil
    }
    
    func didSelect(at indexPath: IndexPath) {
        if filteredCountryDetails.keys.count > indexPath.row {
            let key = Array(filteredCountryDetails.keys)[indexPath.row]
            selectedCountryName.value = key
        }
    }
    
    // MARK: - Filter
    func filterResult(by searchQuery: String) {
        let filtered = countryDetails.filter({ $0.key.lowercased().contains(searchQuery.lowercased())})
        filteredCountryDetails = filtered
        shouldReload.value = true
    }
    
    func resetFilter() {
        filteredCountryDetails = countryDetails
        shouldReload.value = true
    }
}
