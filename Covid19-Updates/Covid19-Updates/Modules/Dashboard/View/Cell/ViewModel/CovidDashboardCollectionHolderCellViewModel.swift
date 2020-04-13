//
//  CovidDashboardCollectionHolderCellViewModel.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 06/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation

enum Row: String, CaseIterable {
    case all = "All Cases"
    case today = "Today"
    case totalDeath = "Total Deaths"
    case todayDeath = "Total Deaths Today"
    case recovered = "Recovered"
    case active = "Active"
    case critical = "Critical"
    case casePerOneMilion = "Cases per Million"
    case deathsPerOneMilion = "Deaths per Million"
    case affectedCountry = "Affected Countries"
    
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

final class CovidDashboardCollectionHolderCellViewModel: DashboardCellCommonModelable {
    // MARK: Properties
    private var covidData: Covid19Cases
    private var updatedAt: Int64?
    private (set) var timeStampText: String?
    private var rows: [Row] = Row.allCases
    var lastUpdatedAtText: String {
        return NSLocalizedString("Last Updated at", comment: "")
    }
    
    // MARK: - Constructor
    init(with data: Covid19Cases) {
        self.covidData = data
        if let timeStamp = data.timeStamp {
            self.updatedAt = timeStamp
            setupUpdatedDate()
        }
    }
    
    // MARK: - Setup
    private func setupUpdatedDate() {
        if let updatedTime = updatedAt {
            timeStampText = GeneralConstants.convertTimeStampIntoText(for: updatedTime)
        }
    }

    // MARK: - Datasource
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int {
        return rows.count
    }
    
    func value(at indexPath: IndexPath) -> (title: String, value: String)? {
        if rows.count > indexPath.row {
            let row = rows[indexPath.row]
            switch row {
            case .all:
                let value = covidData.cases?.roundedWithAbbreviations ?? GeneralConstants.ReusableText.notAvailableString.localized()
                return (title: row.localized(), value: value)
            case .today:
                let value = covidData.todayCases?.roundedWithAbbreviations ?? GeneralConstants.ReusableText.notAvailableString.localized()
                return (title: row.localized(), value: value)
            case .totalDeath:
                let value = covidData.deaths?.roundedWithAbbreviations ?? GeneralConstants.ReusableText.notAvailableString.localized()
                return (title: row.localized(), value: value)
            case .todayDeath:
                let value = covidData.todayDeaths?.roundedWithAbbreviations ?? GeneralConstants.ReusableText.notAvailableString.localized()
                return (title: row.localized(), value: value)
            case .recovered:
                let value = covidData.recovered?.roundedWithAbbreviations ?? GeneralConstants.ReusableText.notAvailableString.localized()
                return (title: row.localized(), value: value)
            case .active:
                let value = covidData.active?.roundedWithAbbreviations ?? GeneralConstants.ReusableText.notAvailableString.localized()
                return (title: row.localized(), value: value)
            case .critical:
                let value = covidData.critical?.roundedWithAbbreviations ?? GeneralConstants.ReusableText.notAvailableString.localized()
                return (title: row.localized(), value: value)
            case .casePerOneMilion:
                var value = GeneralConstants.ReusableText.notAvailableString.localized()
                if let item = covidData.casesPerOneMillion {
                    value = "\(item)"
                }
                return (title: row.localized(), value: value)
            case .deathsPerOneMilion:
                if let value = covidData.deathsPerOneMillion {
                    return (title: row.localized(), value: "\(value)%")
                }
                return (title: row.localized(), value: GeneralConstants.ReusableText.notAvailableString.localized())
            case .affectedCountry:
                if let value = covidData.affectedCountries {
                    return (title: row.localized(), value: "\(value)")
                }
                return nil
            }
        }
        return nil
    }
}

extension CovidDashboardCollectionHolderCellViewModel {
    var countryName: String? {
        return self.covidData.country ?? NSLocalizedString("More Details", comment: "")
    }
}
