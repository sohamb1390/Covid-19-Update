//
//  NSObject+Observable.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 12/11/19.
//  Copyright © 2019 Soham Bhattacharjee. All rights reserved.
//

import Foundation

extension NSObject {
    func observe<T>(for observables: [Observable<T>], with: @escaping (T) -> Void) {
        for observable in observables {
            observable.bind { (_, value)  in
                DispatchQueue.main.async {
                    with(value)
                }
            }
        }
    }
    
    func observe<T>(for observable: Observable<T>?, with: @escaping (T) -> Void) {
        observable?.bind { (_, value)  in
            DispatchQueue.main.async {
                with(value)
            }
        }
    }
}
