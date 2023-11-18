//
//  AddTransactionViewModel.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/10/23.
//

import Foundation

class AddTransactionViewModel: ObservableObject {
    
    @Published var transactionType: TransactionType = TransactionType.EXPENSE
    @Published var transactionTitle: String = ""
    @Published var transactionAmount: String = ""
    @Published var transactionCategory: TransactionCategory = TransactionCategory.Miscellaneous
    @Published var transactionDate: Date = Date.now
    @Published var transactionNote: String = ""
    
    
    var transactionId: String?
    
    var isUpdating: Bool { transactionId != nil }
    
    init() {}
    
    init(transactionResponseToUpdate oldTransactionResponse: TransactionResponse) {
        transactionId = oldTransactionResponse.id
        transactionType = TransactionType.fromString(oldTransactionResponse.transactionType)
        transactionTitle = oldTransactionResponse.title
        transactionAmount = oldTransactionResponse.amount.description
        transactionCategory = TransactionCategory.fromString(oldTransactionResponse.category)
        transactionDate = Helper.stringToDate(oldTransactionResponse.transactionDate)
        transactionNote = oldTransactionResponse.note
    }
    
    var isComplete: Bool {
        return true
    }
    
    
    
    func saveTransaction() {
        
    }
    
    func updateTransaction() {
        
    }
    
}
