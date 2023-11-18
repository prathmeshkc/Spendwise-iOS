//
//  DeveloperPreview.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/4/23.
//

import Foundation

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init () {}
    
    let transactions = [
        TransactionResponse(transactionId: "1", userId: "user1", title: "Budget ", amount: 150.0, transactionType: "INCOME", category: "Savings & Debts", transactionDate: "Nov 01, 2023", note: "Budget for November 2023"),
        TransactionResponse(transactionId: "2", userId: "user1", title: "T-Mobile Phone Bill", amount: 15.94, transactionType: "EXPENSE", category: "Utilities", transactionDate: "Nov 01, 2023", note: "Phone Bill"),
        TransactionResponse(transactionId: "3", userId: "user2", title: "Onions", amount: 0.42, transactionType: "EXPENSE", category: "Food", transactionDate: "Nov 02, 2023", note: "Sample note 3"),
        TransactionResponse(transactionId: "4", userId: "user2", title: "Mandarins 3 lbs", amount: 2.99, transactionType: "EXPENSE", category: "Food", transactionDate: "Nov 02, 2023", note: ""),
        TransactionResponse(transactionId: "5", userId: "user1", title: "Budget ", amount: 150.0, transactionType: "INCOME", category: "Savings & Debts", transactionDate: "Nov 01, 2023", note: "Budget for November 2023"),
        TransactionResponse(transactionId: "6", userId: "user1", title: "T-Mobile Phone Bill", amount: 15.94, transactionType: "EXPENSE", category: "Utilities", transactionDate: "Nov 01, 2023", note: "Phone Bill"),
        TransactionResponse(transactionId: "7", userId: "user2", title: "Onions", amount: 0.42, transactionType: "EXPENSE", category: "Food", transactionDate: "Nov 02, 2023", note: "Sample note 3"),
        TransactionResponse(transactionId: "8", userId: "user2", title: "Mandarins 3 lbs", amount: 2.99, transactionType: "EXPENSE", category: "Food", transactionDate: "Nov 02, 2023", note: "")
    ]
}
