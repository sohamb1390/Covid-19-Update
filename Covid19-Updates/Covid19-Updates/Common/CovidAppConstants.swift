//
//  CovidAppConstants.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 05/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation

/// A completion closure which will return optional generic object(s) and an optional error instance
typealias Handler = (_ modelData: Codable?, _ error: NetworkError?) -> Void

struct CovidAppStyle {
    enum Colors: Int {
        case green = 0x63b735
        case red = 0xF05050
        case base = 0x27b79d
        case border = 0xD8D8D8
        case text = 0x333333
        case segmentBackground = 0xF5F5F5
    }
}

/// Debug Mode for print
func DPrint(_ items: Any...) {
    #if DEBUG
    
    var startIdx = items.startIndex
    let endIdx = items.endIndex
    
    repeat {
        Swift.print(items[startIdx])
        startIdx += 1
    } while startIdx < endIdx
    
    #endif
}

struct GeneralConstants {
    enum ReusableText: String {
        case notAvailableString = "N/A"
        
        func localized() -> String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
}

final class CovidDateFormatter: NSObject {
    // MARK: Variables
    static let shared = CovidDateFormatter()
    private (set) var dateFormatter: DateFormatter
    
    // MARK: - Init
    private override init() {
        self.dateFormatter = DateFormatter()
        super.init()
    }
}
