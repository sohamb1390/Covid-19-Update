//
//  CovidDashboardCellViewModel.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 05/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation

protocol DashboardCellCommonModelable {}

struct CovidDashboardCellViewModel: DashboardCellCommonModelable {
    // MARK: Properties
    var title: String
    var subtitle: String
}
