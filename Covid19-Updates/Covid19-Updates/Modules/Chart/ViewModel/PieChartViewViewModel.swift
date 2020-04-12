//
//  PieChartViewViewModel.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 11/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation
import Charts

final class PieChartViewViewModel: NSObject {
    // MARK: Properties
    private var countryWiseData: [CovidJohnHopkinsData] = []
    private (set) var selectedCountryName: Observable<String> = Observable()
    private var allCountries: [String] = []
    private var countryListViewModel: CovidCountryListViewModel?
    var chartTitle: String {
        return NSLocalizedString("John Hopkins Data", comment: "")
    }
    var lastUpdatedAtText: String {
        if let countryName = selectedCountryName.value, let details = countryWiseData.first(where: { $0.country == countryName || $0.province == countryName }), let lastUpdatedDate = details.updatedAt {
            return "\(NSLocalizedString("Last updated at", comment: "")) \(lastUpdatedDate)"
        }
        return ""
    }
    
    // MARK: - Constructor
    init(with data: [CovidJohnHopkinsData]) {
        self.countryWiseData = data
        super.init()
        self.allCountries = data.map({ (details) in
            if details.province == nil {
                return details.country
            }
            return details.province
            })
            .compactMap({ $0 })
            .sorted(by: { $0 < $1 })
        
        self.selectedCountryName.value = allCountries.first
    }
    
    // MARK: - Setup Datasource
    func setupData() -> [PieChartDataEntry] {
        var entries: [PieChartDataEntry] = []
        if let fileterdCountryInfo = countryWiseData.first(where: { $0.province == selectedCountryName.value || $0.country == selectedCountryName.value }) {
            if let totalItem = fileterdCountryInfo.stats?.confirmed, totalItem > 0 {
                entries.append(PieChartDataEntry(value: Double(totalItem), label: NSLocalizedString("Cases", comment: "")))
            }
            
            if let totalItem = fileterdCountryInfo.stats?.deaths, totalItem > 0 {
                entries.append(PieChartDataEntry(value: Double(totalItem), label: NSLocalizedString("Deaths", comment: "")))
            }
            
            if let totalItem = fileterdCountryInfo.stats?.recovered, totalItem > 0 {
                entries.append(PieChartDataEntry(value: Double(totalItem), label: NSLocalizedString("Recovered", comment: "")))
            }
        }
        return entries
    }
    
    private func getFlagIcon(of name: String) -> NSUIImage? {
        if let dataPath = CovidDashboardViewModel.imageFolderPath {
            let filepath = "\(dataPath.path)/\(name).png"
            return NSUIImage(contentsOfFile: filepath)
        } else {
            DPrint("Image Folder Path is missing")
            return nil
        }
    }
    
    func getCountryListViewModel() -> CovidCountryListViewModel {
        var countryDetails: [String: NSUIImage?] = [:]
        for countryName in allCountries {
            var imageName = countryName
            if countryName == "United Arab Emirates" {
                imageName = "UAE"
            } else if countryName == "United Kingdom" {
                imageName = "UK"
            }
            let image = getFlagIcon(of: imageName)
            countryDetails[countryName] = image
        }
        let countryListViewModel = CovidCountryListViewModel(with: countryDetails, selectedCountryName: selectedCountryName.value ?? "")
        countryListViewModel.observe(for: countryListViewModel.selectedCountryName, with: { [weak self] (name) in
            self?.selectedCountryName.value = name
        })
        return countryListViewModel
    }

    // MARK: - Change Filter
    func updateCountry(by value: String) {
        if allCountries.contains(value) {
            selectedCountryName.value = value
        }
    }
}
