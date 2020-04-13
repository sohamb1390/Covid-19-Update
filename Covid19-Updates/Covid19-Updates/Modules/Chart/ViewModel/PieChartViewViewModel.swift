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
    private var countryWiseData: [Covid19Cases] = []
    private (set) var selectedCountryName: Observable<String> = Observable()
    private var allCountries: [String] = []
    private var countryListViewModel: CovidCountryListViewModel?
    var lastUpdatedAtText: String {
        if let countryName = selectedCountryName.value, let details = countryWiseData.first(where: { $0.country == countryName}), let timeStamp = details.timeStamp {
            let timeStampText = GeneralConstants.convertTimeStampIntoText(for: timeStamp)
            return "\(NSLocalizedString("Last updated at", comment: "")) \(timeStampText)"
        }
        return ""
    }
    
    // MARK: - Constructor
    init(with data: [Covid19Cases]) {
        self.countryWiseData = data
        super.init()
        self.allCountries = data.map({ (details) in
            return details.country
            })
            .compactMap({ $0 })
            .sorted(by: { $0 < $1 })
        
        self.selectedCountryName.value = allCountries.first
    }
    
    // MARK: - Setup Datasource
    func setupData() -> [PieChartDataEntry] {
        var entries: [PieChartDataEntry] = []
        if let fileterdCountryInfo = countryWiseData.first(where: { $0.country == selectedCountryName.value }) {
            if let totalItem = fileterdCountryInfo.cases, totalItem > 0 {
                entries.append(PieChartDataEntry(value: Double(totalItem), label: NSLocalizedString("Cases", comment: "")))
            }
            
            if let totalItem = fileterdCountryInfo.deaths, totalItem > 0 {
                entries.append(PieChartDataEntry(value: Double(totalItem), label: NSLocalizedString("Deaths", comment: "")))
            }
            
            if let totalItem = fileterdCountryInfo.recovered, totalItem > 0 {
                entries.append(PieChartDataEntry(value: Double(totalItem), label: NSLocalizedString("Recovered", comment: "")))
            }
            
            if let totalItem = fileterdCountryInfo.critical, totalItem > 0 {
                entries.append(PieChartDataEntry(value: Double(totalItem), label: NSLocalizedString("Critical", comment: "")))
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
            let image = getFlagIcon(of: countryName)
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
