//
//  ExpenditureByCategory.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 12/6/23.
//

import Foundation
import SwiftUI


/// Struct to represent a category and its expenditure percentage.
struct ExpenditureByCategory: Identifiable {
    let category: String
    let percentage: Double
    var color: Color {
        switch category {
            case "Entertainment":
                Colors.Entertainment
            case "Food":
                Colors.Food
            case "Healthcare":
                Colors.Healthcare
            case "Housing" :
                Colors.Housing
            case "Insurance" :
                Colors.Insurance
            case "Miscellaneous" :
                Colors.Miscellaneous
            case "PersonalSpending" :
                Colors.PersonalSpending
            case "Savings & Debts":
                Colors.SavingsnDebts
            case "Transportation" :
                Colors.Transportation
            case "Utilities" :
                Colors.Utilities
            default:
                Colors.Miscellaneous
        }
    }
    var id: String {
        category
    }
}
