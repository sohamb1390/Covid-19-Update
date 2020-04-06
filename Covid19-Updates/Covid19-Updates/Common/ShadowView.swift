//
//  ShadowView.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 09/11/19.
//  Copyright © 2019 Soham Bhattacharjee. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ShadowView: UIView {
    // IBInspectable Propeties
    @IBInspectable
    var shadowColor: UIColor = UIColor.black.withAlphaComponent(0.4) {
        didSet {
            layer.shadowColor = self.shadowColor.cgColor
        }
    }
  
    @IBInspectable
    var borderColor: UIColor = UIColor(appColor: .border) {
        didSet {
            layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 10.0 {
        didSet {
            layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float = 10.0 {
        didSet {
            layer.shadowOpacity = self.shadowOpacity
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat = 20.0 {
        didSet {
            layer.shadowRadius = self.shadowRadius
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutView()
    }
    
    // MARK: - Layout View
    private func layoutView() {
        // set the shadow of the view's layer
        // layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.masksToBounds = false
    }
}
