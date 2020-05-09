//
//  CovidMapViewController.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 07/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import UIKit
import MapKit

class CovidMapViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Prperties
    private var viewModel: CovidMapViewModel?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .unspecified
        bind(to: CovidMapViewModel(with: CovidSharedData.shared.countryWiseCases))
        configureMap()
        registerAnnotationViewClasses()
        viewModel?.setupAnnotations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Config
    func configureMap() {
        mapView.delegate = self
        
        mapView.showsTraffic = false
        
        mapView.showsCompass = false
        
        mapView.isPitchEnabled = false
        
        mapView.showsUserLocation = true
        
        mapView.showsUserLocation = true
    }
    
    func registerAnnotationViewClasses() {
        mapView.register(CovidAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(CovidClusterAnnotationView.self,
                      forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
}
// MARK: - Binding
extension CovidMapViewController: CovidBindable {
    typealias T = CovidMapViewModel
    
    func bind(to model: CovidMapViewModel) {
        self.viewModel = model
        self.viewModel?.observe(for: self.viewModel?.annotations, with: { [weak self] (annotations) in
            self?.mapView.removeAnnotations(self?.mapView.annotations ?? [])
            self?.mapView.addAnnotations(annotations)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let region = MKCoordinateRegion(.world)
                self?.mapView.setRegion(region, animated: true)
            }
        })
    }
}

// MARK: - MapViewDelegate
extension CovidMapViewController: MKMapViewDelegate {
    /// Called whent he user taps the disclosure button in the bridge callout.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        // This illustrates how to detect which annotation type was tapped on for its callout.
        if let annotation = view.annotation as? CovidAnnotation {
            DPrint("Tapped \(annotation.title ?? "")")
            
            if let navigationController = UIViewController.getViewController(ofType: UINavigationController.self, fromStoryboardName: "CovidDetails", storyboardId: "CovidDetailsNavigationController", bundle: .main),
                let detailsViewController = navigationController.viewControllers.first as? CovidDetailsViewController {
                
                let countryDetailsVM = CovidDashboardCollectionHolderCellViewModel(with: annotation.detailData)
                
                detailsViewController.bind(to: countryDetailsVM)
                
                navigationController.modalPresentationStyle = .popover
                let presentationController = navigationController.popoverPresentationController
                presentationController?.permittedArrowDirections = .any
                
                // Anchor the popover to the button that triggered the popover.
                presentationController?.sourceRect = control.frame
                presentationController?.sourceView = control
                
                present(navigationController, animated: true, completion: nil)
            }
        }
    }
}
