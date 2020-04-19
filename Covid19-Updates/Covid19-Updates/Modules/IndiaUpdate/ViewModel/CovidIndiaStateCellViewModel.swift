//
//  CovidIndiaStateCellViewModel.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 19/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation

struct CovidIndiaStateCellViewModel: DashboardCellCommonModelable {
    // MARK: Properties
    let locationName: String
    let casesCount: String
    let fatalityCount: String
    let recoveredCount: String
    let infectedIndiansCount: String
    let infectedForeignersCount: String
    
    var casesCountTitle: String {
        return NSLocalizedString("Cases", comment: "")
    }
    
    var fatalityTitle: String {
        return NSLocalizedString("Fatalities", comment: "")
    }
    
    var recoveredTitle: String {
        return NSLocalizedString("Recovered", comment: "")
    }
    
    var infectedIndiansCountTitle: String {
        return NSLocalizedString("Infected Indians", comment: "")
    }
    
    var infectedForeignersCountTitle: String {
        return NSLocalizedString("Infected Foreigners", comment: "")
    }
}
