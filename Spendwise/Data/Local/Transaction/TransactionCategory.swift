//
//  TransactionCategory.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/11/23.
//

import Foundation

enum TransactionCategory: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case Entertainment = "Entertainment"
    case Food = "Food"
    case Healthcare = "Healthcare"
    case Housing = "Housing"
    case Insurance = "Insurance"
    case Miscellaneous = "Miscellaneous"
    case PersonalSpending = "Personal Spending"
    case SavingsAndDebts = "Savings & Debts"
    case Transportation = "Transportation"
    case Utilities = "Utilities"
    
    /**
     Function to map a string value to the corresponding enum case
     */
    static func fromString(_ value: String) -> TransactionCategory {
        return self.allCases.first { $0.rawValue == value } ?? .Miscellaneous
    }
    
    
}
