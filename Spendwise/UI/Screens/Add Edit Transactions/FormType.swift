//
//  FormType.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/17/23.
//

import Foundation
import SwiftUI

enum FormType: Identifiable, View {
    case new
    case update(TransactionResponse)
    var id: String {
        switch self {
            case .new:
                return "new"
            case .update:
                return "update"
        }
    }
    
    var body: some View {
        switch self {
            case .new:
                return AddTransactionScreen(addTransactionViewModel: AddTransactionViewModel())
            case .update(let transactionResponse):
                return AddTransactionScreen(addTransactionViewModel: AddTransactionViewModel(transactionResponseToUpdate: transactionResponse))
        }
    }
    
}
