//
//  Observable.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 12/11/19.
//  Copyright © 2019 Soham Bhattacharjee. All rights reserved.
//

import Foundation

class Observable<ObservedType> {
    
    // MARK: Variables
    typealias Observer = (_ observable: Observable<ObservedType>, ObservedType) -> Void
    
    var observers: [Observer]
    
    var value: ObservedType? {
        didSet {
            if let value = value {
                notifyObservers(value)
            }
        }
    }
    
    // MARK: Initialisation
    init(_ value: ObservedType? = nil) {
        self.value = value
        observers = []
    }
    
    // MARK: - Binder
    func bind(observer: @escaping Observer) {
        self.observers.append(observer)
    }
    
    // MARK: - Notifier
    func notifyObservers(_ value: ObservedType) {
        self.observers.forEach { [unowned self] (observer) in
            observer(self, value)
        }
    }
    
    func removeObservers() {
        self.observers.removeAll()
    }
}
