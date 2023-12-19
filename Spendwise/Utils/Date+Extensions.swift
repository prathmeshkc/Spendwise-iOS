//
//  Date+Extensions.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 12/14/23.
//

import Foundation


extension Date {
    var startOfMonth: Date {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        // Get the range for the current month
        if let _ = calendar.range(of: .day, in: .month, for: self) {
            // Get the first day of the month
            let firstDayComponents = calendar.dateComponents([.year, .month], from: self)
            let firstDay = calendar.date(from: firstDayComponents)!
            Logger.logMessage(message: "Helper::getFirstDayOfCurrentMonthFormatted -> Start Date of the Month - \(firstDay)")
            return firstDay
        }
        
        // Default return if unable to calculate
        return self
    }
    
    
    var endOfMonth: Date {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        // Get the range for the current month
        if let _ = calendar.range(of: .day, in: .month, for: self) {
            // Get the first day of the month
            let firstDayComponents = calendar.dateComponents([.year, .month], from: self)
            let firstDay = calendar.date(from: firstDayComponents)!
            
            // Get the last day of the month
            var lastDayComponents = DateComponents()
            lastDayComponents.month = 1
            lastDayComponents.day = -1
            let lastDay = calendar.date(byAdding: lastDayComponents, to: firstDay)!
            Logger.logMessage(message: "Helper::getLastDayOfCurrentMonthFormatted -> Start Date of the Month - \(lastDay)")
            return lastDay
        }
        
        // Default return if unable to calculate
        return self
    }
    
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
}
