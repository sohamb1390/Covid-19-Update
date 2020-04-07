//
//  CovidAnnotation.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 07/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation
import MapKit

final class CovidAnnotation: MKPointAnnotation {
    private var data: Covid19Cases

    // MARK: - Constructor
    init(with data: Covid19Cases) {
        self.data = data
        super.init()
    }
    
    // MARK: Getters
    var detailData: Covid19Cases {
        return data
    }
    
    var countryName: String {
        return data.country ?? GeneralConstants.ReusableText.notAvailableString.rawValue
    }

    var totalCases: String {
        if let totalCases = data.cases {
            return "\(totalCases)"
        }
        return GeneralConstants.ReusableText.notAvailableString.rawValue
    }
//
//    var totalDeaths: String {
//        if let totalDeaths = data.deaths {
//            return "\(totalDeaths)"
//        }
//        return GeneralConstants.ReusableText.notAvailableString.rawValue
//    }
//
//    var recovered: String {
//        if let totalRecovered = data.recovered {
//            return "\(totalRecovered)"
//        }
//        return GeneralConstants.ReusableText.notAvailableString.rawValue
//    }
//
//    var active: String {
//        if let totalActiveCases = data.active {
//            return "\(totalActiveCases)"
//        }
//        return GeneralConstants.ReusableText.notAvailableString.rawValue
//    }
//
//    var critical: String {
//        if let totalCriticalCases = data.critical {
//            return "\(totalCriticalCases)"
//        }
//        return GeneralConstants.ReusableText.notAvailableString.rawValue
//    }
}
