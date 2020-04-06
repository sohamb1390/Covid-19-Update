//
//  UIControls+Binding.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 12/11/19.
//  Copyright © 2019 Soham Bhattacharjee. All rights reserved.
//

import Foundation
import UIKit

extension UITextField: Binding {
    
    public typealias BindingType = String
    
    public func observingValue() -> String? {
        return self.text
    }
    
    public func updateValue(with value: String) {
        self.text = value
    }
}

extension UILabel: Binding {
    
    public typealias BindingType = String
    
    public func observingValue() -> String? {
        return self.text
    }
    
    public func updateValue(with value: String) {
        self.text = value
    }
}

extension UISwitch: Binding {
    
    public typealias BindingType = Bool
    
    public func observingValue() -> Bool? {
        return self.isOn
    }
    
    public func updateValue(with value: Bool) {
        self.isOn = value
    }
}

extension UITextView: Binding {
    
    public typealias BindingType = String
    
    public func observingValue() -> String? {
        return self.text
    }
    
    public func updateValue(with value: String) {
        self.text = value
    }
}

extension UISlider: Binding {
    
    public typealias BindingType = Float
    
    public func observingValue() -> Float? {
        return self.value
    }
    
    public func updateValue(with value: Float) {
        self.value = value
    }
}

extension UIStepper: Binding {
    
    public typealias BindingType = Double
    
    public func observingValue() -> Double? {
        return self.value
    }
    
    public func updateValue(with value: Double) {
        self.value = value
    }
}

extension UIBarButtonItem: Binding {
    
    public typealias BindingType = Bool
    
    func observingValue() -> Bool? {
        return self.isEnabled
    }
    
    func updateValue(with value: Bool) {
        self.isEnabled = value
    }
}

extension UIButton: Binding {
    
    public typealias BindingType = Bool
    
    func observingValue() -> Bool? {
        return self.isEnabled
    }
    
    func updateValue(with value: Bool) {
        self.isEnabled = value
    }
}
