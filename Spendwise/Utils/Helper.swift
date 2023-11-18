//
//  Helper.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 10/27/23.
//

import Foundation


class Helper {
    
    
    static func formatDoubleWithTwoDecimals(value: Double) -> String {
        return String(format: "%.2f", value)
    }
    
    static func formatAmountWithLocale(amount: Double, locale: Locale = Locale.current) -> String {
        let roundedAmount = round(amount * 100) / 100.0
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = locale
        
        if let formattedAmount = numberFormatter.string(from: NSNumber(value: roundedAmount)) {
            return formattedAmount
        }
        
        return ""
    }
    
    
    static func stringToDate(_ responseDateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        if let formattedDate = dateFormatter.date(from: responseDateString) {
            debugPrint(formattedDate)
            return formattedDate
        }
        
        Logger.logMessage(message: "Failed to convert string '\(responseDateString)' to Date object", logType: .error)
        return Date.now
        
    }
    
    
    static func stringToDecimal(_ input: String) -> Decimal {
        // Create a NumberFormatter instance
        let numberFormatter = NumberFormatter()
        
        // Set number style to decimal
        numberFormatter.numberStyle = .decimal
        
        // Try to convert the input string to a Decimal value
        if let decimalNumber = numberFormatter.number(from: input) as? Decimal {
            return decimalNumber
        } else {
            return Decimal()
        }
    }
    
    
    static func groupTransactionsByDate(transactionList: [TransactionResponse]) -> [String: [TransactionResponse]] {
        var groupedTransactions: [String: [TransactionResponse]] = [:]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        for transaction in transactionList {
            groupedTransactions[transaction.transactionDate, default: []].append(transaction)
        }
        
        return groupedTransactions
    }
}

