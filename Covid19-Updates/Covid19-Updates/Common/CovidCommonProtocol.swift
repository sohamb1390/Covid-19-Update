//
//  CovidCommonProtocol.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 05/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Generic Bindable Protocol
/// Generic Bindable Protocol.
/// Mostly useful for binding different types of ViewModels to the ViewController
protocol CovidBindable {
    /// Generic Type
    associatedtype T
    /// Binds generic model to the conforming class
    ///
    /// - Parameters:
    ///   - model: generic type model
    func bind(to model: T)
}

protocol NibInstantiatable {
    static func nibName() -> String
}
