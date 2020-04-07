//
//  CovidMapViewModel.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 07/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation
import CoreLocation

final class CovidMapViewModel: NSObject {
    // MARK: Properties
    private var countryWiseData: [Covid19Cases] = []
    private (set) var annotations: Observable<[CovidAnnotation]> = Observable()
    
    // MARK: - Constructor
    init(with data: [Covid19Cases]) {
        self.countryWiseData = data
        super.init()
    }
    
    // MARK: - Setup
    func setupAnnotations() {
        var tempAnnotations: [CovidAnnotation] = []
        for data in countryWiseData {
            if let latitude = data.countryInfo?.latitude, let longitude = data.countryInfo?.longitude {
                let annotation = CovidAnnotation(with: data)
                annotation.title = annotation.countryName
                annotation.subtitle = annotation.totalCases == GeneralConstants.ReusableText.notAvailableString.rawValue ? annotation.totalCases : "\(NSLocalizedString("Total Cases:", comment: "")) \(annotation.totalCases)"
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                tempAnnotations.append(annotation)
            }
        }
        annotations.value = tempAnnotations
    }
}
