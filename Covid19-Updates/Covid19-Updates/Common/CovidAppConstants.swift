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
        case error = "ERROR"
        case retry = "RETRY"
        func localized() -> String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    static func convertTimeStampIntoText(for timeStamp: Int64) -> String {
        let unixTimeStamp: Double = Double(timeStamp) / 1000.0
        let exactDate = Date(timeIntervalSince1970: unixTimeStamp)
        return GeneralConstants.getFormattedDateString(from: exactDate)
    }
    
    static func convertDateIntoText(from date: Date) -> String {
        return GeneralConstants.getFormattedDateString(from: date)
    }
    
    static private func getFormattedDateString(from date: Date) -> String {
        CovidDateFormatter.shared.dateFormatter.timeStyle = .medium // Set time style
        CovidDateFormatter.shared.dateFormatter.dateStyle = .medium // Set date style
        CovidDateFormatter.shared.dateFormatter.timeZone = .current
        return CovidDateFormatter.shared.dateFormatter.string(from: date)
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
