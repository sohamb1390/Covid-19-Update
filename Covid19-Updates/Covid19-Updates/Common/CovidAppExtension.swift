//
//  CovidAppExtension.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 05/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    /// Initialises UIColor with custom app colors
    /// - Parameters:
    ///    - appColor: `AppStyle.Colors` type value
    convenience init(appColor: CovidAppStyle.Colors) {
        self.init(hex: appColor.rawValue)
    }
    
    /// A private constructor which initialises UIColor using hex value
    /// - Parameters:
    ///    - hex: Hex Value of the color
    private convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}

extension NSObject {
    /// Gives the string value of any NSObject instance
    var className: String {
        return String(describing: type(of: self))
    }
    /// Gives the string value of any NSObject instance
    class var className: String {
        return String(describing: self)
    }
}

fileprivate protocol ValueAbbreviation {
    func roundedWithAbbreviations(from value: Double) -> String
}

extension ValueAbbreviation {
    func roundedWithAbbreviations(from value: Double) -> String {
        let number = value
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        } else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        } else {
            return "\(self)"
        }
    }
}

extension Int: ValueAbbreviation {
    var roundedWithAbbreviations: String {
        return self.roundedWithAbbreviations(from: Double(self))
    }
}

extension Int64: ValueAbbreviation {
    var roundedWithAbbreviations: String {
        return self.roundedWithAbbreviations(from: Double(self))
    }
}

extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}

extension UIViewController {
    /// Shows up the activity loader on the screen
    /// - Parameters:
    ///    - message: It takes an optional parameter `message` which is required when you want to show some status while activity is running
    func show(with message: String = "") {
        // IHProgressHUD.set(defaultStyle: traitCollection.userInterfaceStyle == .light ? .light : .dark)
        IHProgressHUD.set(defaultStyle: .dark)
        IHProgressHUD.show(withStatus: message.isEmpty ? nil : message)
    }
    
    /// Dismisses the activity loader on the screen
    /// - Parameters:
    ///    - completion: It takes an optional parameter `completion` which is a type of closure. Pass any closure as an argument only when you want to perform some task inside the closure.
    func dismiss(withCompletion completion: (() -> Void)? = nil) {
        IHProgressHUD.dismissWithCompletion(completion)
    }
    
    /// Dismisses the activity loader on the screen
    /// - Parameters:
    ///    - delay: A `TimeInterval` arguement which is required when you want to dismiss the loader after a specific time
    ///    - completion: It takes an optional parameter `completion` which is a type of closure. Pass any closure as an argument only when you want to perform some task inside the closure.
    func dismiss(withDelay delay: TimeInterval, withCompletion completion: (() -> Void)? = nil) {
        IHProgressHUD.dismissWithDelay(delay, completion: completion)
    }
    
    /// A Common method to present an alert view on the current view controller
    ///
    /// - Parameters:
    ///     - title: A title value of the alert
    ///     - description: It defines the message of the alert
    ///     - type: Type of the alert controller. It could be either normal alert or action sheet
    ///     - sourceRect: An optional `CGRect` property which is required for presenting a popover. It represents the source position from where the popover will be presented.
    ///     - sourceView: An optional `UIView` property which is required for presenting a popover. It represents the source view from where the popover will be presented.
    ///     - actions: An array of UIAlertAction instance which is nil by default. You can provide your own custom actions from the source view controller
    ///     - popoverDelegate: An optional `UIPopoverPresentationControllerDelegate`
    ///     - direction: An optional `UIPopoverArrowDirection` value which is required if you want to present a pop over instead of an alert
    func showAlert(with title: String?,
                   description: String?,
                   type: UIAlertController.Style = .alert,
                   sourceRect: CGRect? = .zero,
                   sourceView: UIView? = UIView(),
                   barButtonItem: UIBarButtonItem? = nil,
                   actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)],
                   popoverDelegate: UIPopoverPresentationControllerDelegate? = nil,
                   direction: UIPopoverArrowDirection = .any) {
        let alertController = UIAlertController(title: title, message: description, preferredStyle: type)
        
        for action in actions {
            alertController.addAction(action)
        }
        
        if type == .actionSheet {
            
            alertController.modalPresentationStyle = .popover
            
            if let barButtonItem = barButtonItem {
                alertController.popoverPresentationController?.barButtonItem = barButtonItem
            } else {
                alertController.popoverPresentationController?.sourceView = sourceView
                alertController.popoverPresentationController?.sourceRect = sourceRect ?? .zero
            }
            alertController.popoverPresentationController?.permittedArrowDirections = direction
            alertController.popoverPresentationController?.delegate = popoverDelegate
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// Initialises Any type of UIViewController
    ///
    /// - Parameters:
    ///   - type: A generic instance of type UIViewController
    ///   - storyboardName: A String value which defines the storyboard name from which the UIViewController should be initialised
    ///   - storyboardId: A String value which defines an unique identifier for each UIViewController instance
    ///   - bundle: A Bundle instance
    /// - Returns: Type of UIViewController
    class func getViewController<T>(ofType type: T.Type,
                                    fromStoryboardName storyboardName: String,
                                    storyboardId: String,
                                    bundle: Bundle) -> T? where T: UIViewController {
        let designatedViewController = UIStoryboard(name: storyboardName, bundle: bundle).instantiateViewController(withIdentifier: storyboardId)
        return designatedViewController as? T
    }
}

extension UIView {
    func parentView<T: UIView>(of type: T.Type) -> T? {
        guard let view = superview else {
            return nil
        }
        return (view as? T) ?? view.parentView(of: T.self)
    }
}

extension UITableViewCell {
    var tableView: UITableView? {
        return parentView(of: UITableView.self)
    }
    
    var indexPath: IndexPath? {
        return tableView?.indexPath(for: self)
    }
}

extension NibInstantiatable {
    static func nibName() -> String {
        return String(describing: self)
    }
}

extension NibInstantiatable where Self: UIView {
    static func fromNib() -> Self? {
        let bundle = Bundle(for: self)
        let nib = bundle.loadNibNamed(nibName(), owner: self, options: nil)
        return nib?.first as? Self
    }
}
