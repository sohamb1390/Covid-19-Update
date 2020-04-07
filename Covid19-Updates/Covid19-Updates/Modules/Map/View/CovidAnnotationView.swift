//
//  CovidAnnotationView.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 07/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation

import MapKit

final class CovidAnnotationView: MKMarkerAnnotationView {
    static let preferredClusteringIdentifier = Bundle.main.bundleIdentifier! + ".AnnotationView"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = CovidAnnotationView.preferredClusteringIdentifier
        collisionMode = .circle
        displayPriority = .defaultHigh
        titleVisibility = .visible
        subtitleVisibility = .visible
        animatesWhenAdded = true
        let calloutButton = UIButton(type: .detailDisclosure)
        rightCalloutAccessoryView = calloutButton
        canShowCallout = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            markerTintColor = UIColor(named: "AppRed") ?? UIColor(appColor: .red)
            clusteringIdentifier = CovidAnnotationView.preferredClusteringIdentifier
        }
    }
}
