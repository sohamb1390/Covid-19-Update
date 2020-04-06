//
//  CovidRoundButton.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 15/03/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CovidRoundButton: UIButton {
    // MARK: Properties
    @IBInspectable
    var cornerRadius: CGFloat = 10.0 {
        didSet {
            layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .init(appColor: .base) {
        didSet {
            layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable
    var normalStateTitleColor: UIColor = .white {
        didSet {
            setTitleColor(self.normalStateTitleColor, for: .normal)
        }
    }
    
    @IBInspectable
    var selectedStateTitleColor: UIColor = .init(appColor: .base) {
        didSet {
            setTitleColor(self.selectedStateTitleColor, for: .selected)
        }
    }
    
    @IBInspectable
    var bgColor: UIColor = .init(appColor: .base) {
        didSet {
            backgroundColor = self.bgColor
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = self.isEnabled ? self.bgColor : self.bgColor.withAlphaComponent(0.5)
        }
    }
    
    // MARK: - Lifecycle
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Layout View
    func layoutView() {
        // set the shadow of the view's layer
        // layer.backgroundColor = UIColor.clear.cgColor
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.masksToBounds = false
        setTitleColor(normalStateTitleColor, for: .normal)
        setTitleColor(selectedStateTitleColor, for: .selected)
        backgroundColor = bgColor
    }
}
