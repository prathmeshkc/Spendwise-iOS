//
//  TransactionType.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 10/26/23.
//

import Foundation


enum TransactionType: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case INCOME  = "INCOME"
    case EXPENSE = "EXPENSE"
    
    
    static func fromString(_ value: String) -> TransactionType {
        return self.allCases.first { $0.rawValue == value } ?? .EXPENSE
        }
}
