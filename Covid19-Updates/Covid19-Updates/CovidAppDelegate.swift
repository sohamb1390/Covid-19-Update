//
//  AppDelegate.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 05/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import UIKit
import Reachability

@UIApplicationMain
class CovidAppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties
    private (set) var reachability: Reachability?

    /// A static AppDelegate instance which can be retrieved from anywhere of the app
    static var appDelegateInstance: CovidAppDelegate? {
        var appDelegate: CovidAppDelegate?
        
        if Thread.isMainThread {
            return UIApplication.shared.delegate as? CovidAppDelegate
        }
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        DispatchQueue.main.async {
            appDelegate = UIApplication.shared.delegate as? CovidAppDelegate
            dispatchGroup.leave()
        }
        
        dispatchGroup.wait()
        
        return appDelegate
    }
    
    var window: UIWindow?
    
    // MARK: - UIApplication Lifecycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Start reachability
        startReachability()

        return true
    }

    // MARK: - Reachability Helper
    private func startReachability() {
        reachability = try? Reachability()
        
        reachability?.whenReachable = { (reachability) in
            if reachability.connection == .wifi {
                DPrint("Reachable via WiFi")
            } else {
                DPrint("Reachable via Cellular")
            }
        }
        
        reachability?.whenUnreachable = { (_) in
            DPrint("Not reachable")
        }

        do {
            try reachability?.startNotifier()
        } catch {
            DPrint("Unable to start notifier")
        }
    }
    
    private func stopReachability() {
        reachability?.stopNotifier()
    }
}

