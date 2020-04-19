//
//  CovidIndiaCollectionTableViewCellViewModel.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 18/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation

enum CovidIndiaTrackerRow: String, CaseIterable {
    case totalCases = "Cases"
    case indianCases = "Infected Indians"
    case foreignerCases = "Infected Foreigners"
    case totalDeaths = "Fatalities"
    case totalDischarged = "Recovered"
    
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

final class CovidIndiaCollectionTableViewCellViewModel: DashboardCellCommonModelable {
    // MARK: Properties
    private let rows = CovidIndiaTrackerRow.allCases
    var lastUpdatedAtText: String {
        return NSLocalizedString("Last Updated at", comment: "")
    }
    private var data: CovidIndiaSummary
    private var lastRefreshedDate: Date?
    
    // MARK: - Constructor
    init(with data: CovidIndiaSummary, lastUpdatedDate: Date?) {
        self.data = data
        self.lastRefreshedDate = lastUpdatedDate
    }
    
    // MARK: - Datasource
    func getLastUpdatedDate() -> String {
        if let updatedTime = lastRefreshedDate {
            let dateString = GeneralConstants.convertDateIntoText(from: updatedTime)
            return dateString.isEmpty ? NSLocalizedString("Could not refresh last updated time", comment: "") : dateString
        }
        return NSLocalizedString("Could not refresh last updated time", comment: "")
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int {
        return rows.count
    }
    
    func item(at indexPath: IndexPath) -> CovidDashboardCellViewModel? {
        if rows.count > indexPath.row {
            let row = rows[indexPath.row]
            let title = row.localized()
            let notAvailableItem = (title: title, details: GeneralConstants.ReusableText.notAvailableString.localized())
            switch row {
            case .totalCases:
                if let totalCases = data.totalCase {
                    return CovidDashboardCellViewModel(title: title, subtitle: "\(totalCases)")
                } else {
                    return CovidDashboardCellViewModel(title: title, subtitle: "\(notAvailableItem)")
                }
            case .indianCases:
                if let totalCases = data.confirmedInfectedIndians {
                    return CovidDashboardCellViewModel(title: title, subtitle: "\(totalCases)")
                } else {
                    return CovidDashboardCellViewModel(title: title, subtitle: "\(notAvailableItem)")
                }
            case .foreignerCases:
                if let totalCases = data.confirmedInfectedForeigners {
                    return CovidDashboardCellViewModel(title: title, subtitle: "\(totalCases)")
                } else {
                    return CovidDashboardCellViewModel(title: title, subtitle: "\(notAvailableItem)")
                }
            case .totalDeaths:
                if let totalCases = data.totalDeaths {
                    return CovidDashboardCellViewModel(title: title, subtitle: "\(totalCases)")
                } else {
                    return CovidDashboardCellViewModel(title: title, subtitle: "\(notAvailableItem)")
                }
            case .totalDischarged:
                if let totalCases = data.totalRecovered {
                    return CovidDashboardCellViewModel(title: title, subtitle: "\(totalCases)")
                } else {
                    return CovidDashboardCellViewModel(title: title, subtitle: "\(notAvailableItem)")
                }
            }
        }
        return nil
    }
}
