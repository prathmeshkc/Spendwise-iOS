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
    
    static func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
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
        
        for transaction in transactionList {
            groupedTransactions[transaction.transactionDate, default: []].append(transaction)
        }
        
        return groupedTransactions
    }
    
    
    static func getFirstAndLastDayOfCurrentMonthFormatted() -> (firstDay: String, lastDay: String) {
        let calendar = Calendar.current
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        // Get the range for the current month
        if let _ = calendar.range(of: .day, in: .month, for: currentDate) {
            // Get the first day of the month
            let firstDayComponents = calendar.dateComponents([.year, .month], from: currentDate)
            let firstDay = calendar.date(from: firstDayComponents)!
            let firstDayFormatted = dateFormatter.string(from: firstDay)
            
            // Get the last day of the month
            var lastDayComponents = DateComponents()
            lastDayComponents.month = 1
            lastDayComponents.day = -1
            let lastDay = calendar.date(byAdding: lastDayComponents, to: firstDay)!
            let lastDayFormatted = dateFormatter.string(from: lastDay)
            Logger.logMessage(message: "Helper::getFirstAndLastDayOfCurrentMonthFormatted -> Start Date of the Month - \(firstDayFormatted), Last Date of the month - \(lastDayFormatted)")
            
            return (firstDayFormatted, lastDayFormatted)
        }
        
        // Default return if unable to calculate
        return ("", "")
    }
    
    static func getFirstDayOfCurrentMonthFormatted() -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        // Get the range for the current month
        if let _ = calendar.range(of: .day, in: .month, for: currentDate) {
            // Get the first day of the month
            let firstDayComponents = calendar.dateComponents([.year, .month], from: currentDate)
            let firstDay = calendar.date(from: firstDayComponents)!
            let firstDayFormatted = dateFormatter.string(from: firstDay)
            Logger.logMessage(message: "Helper::getFirstDayOfCurrentMonthFormatted -> Start Date of the Month - \(firstDayFormatted)")
            return firstDayFormatted
        }
        
        // Default return if unable to calculate
        return ""
    }

    static func getLastDayOfCurrentMonthFormatted() -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        // Get the range for the current month
        if let _ = calendar.range(of: .day, in: .month, for: currentDate) {
            // Get the first day of the month
            let firstDayComponents = calendar.dateComponents([.year, .month], from: currentDate)
            let firstDay = calendar.date(from: firstDayComponents)!
            
            // Get the last day of the month
            var lastDayComponents = DateComponents()
            lastDayComponents.month = 1
            lastDayComponents.day = -1
            let lastDay = calendar.date(byAdding: lastDayComponents, to: firstDay)!
            let lastDayFormatted = dateFormatter.string(from: lastDay)
            Logger.logMessage(message: "Helper::getLastDayOfCurrentMonthFormatted -> Start Date of the Month - \(lastDayFormatted)")
            return lastDayFormatted
        }
        
        // Default return if unable to calculate
        return ""
    }

    
    static func containsOnlyWhitespace(_ input: String) -> Bool {
        // Remove whitespaces and newlines from the input string
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if the trimmed string is empty (contains only whitespaces)
        return trimmed.isEmpty
    }
    
    static func trimLeadingZeros(from number: Double) -> Double {
        let numberAsString = String(number)
        if let trimmed = Double(numberAsString) {
            return trimmed
        } else {
            // If unable to convert back to Double, return the original number
            return number
        }
    }
    
    static func calculateSummary(transactions: [TransactionResponse]) -> (income: Double, expense: Double, balance: Double) {
        let incomeTransactions = transactions.filter { $0.transactionType == TransactionType.INCOME.rawValue }
        let expenseTransactions = transactions.filter { $0.transactionType == TransactionType.EXPENSE.rawValue }
        
        let totalIncome = incomeTransactions.reduce(0.0) { $0 + $1.amount }
        let totalExpense = expenseTransactions.reduce(0.0) { $0 + $1.amount }
        let balance = totalIncome - totalExpense
        
        return (income: totalIncome, expense: totalExpense, balance: balance)
    }
    
    
    
        static func calculateExpenditurePercentageByCategory(from transactionList: [TransactionResponse]) -> [ExpenditureByCategory] {
    
            let expenseTransactions = transactionList.filter { $0.transactionType == TransactionType.EXPENSE.rawValue }
    
            let groupedByCategory = Dictionary(grouping: expenseTransactions, by: { $0.category })
    
            // Step 2: Calculate total expenditure for each category
            var expenditureByCategory: [String: Double] = [:] // Dictionary to hold total expenditure by category
    
            for (category, transactions) in groupedByCategory {
                let totalExpenditure = transactions.reduce(0.0) { $0 + $1.amount }
                expenditureByCategory[category] = totalExpenditure
            }
    
            // Step 3: Calculate percentage for each category
            let totalExpenditure = expenditureByCategory.values.reduce(0.0, +)
            var expenditurePercentageByCategory: [ExpenditureByCategory] = []
    
            for (category, expenditure) in expenditureByCategory {
                let percentage = (expenditure / totalExpenditure) * 100
                let expenditureCategory = ExpenditureByCategory(category: category, percentage: percentage)
                expenditurePercentageByCategory.append(expenditureCategory)
            }
    
            expenditurePercentageByCategory.forEach { expenditureByCategory in
                print("\(expenditureByCategory.percentage)")
            }
    
            return expenditurePercentageByCategory
        }
    
    
    
    
    
    
    
}

