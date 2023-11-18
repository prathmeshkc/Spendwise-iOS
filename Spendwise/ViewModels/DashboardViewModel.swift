//
//  DashboardViewModel.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/10/23.
//

import Foundation


class DashboardViewModel: ObservableObject {
    
    
    @Published var transactionList: [TransactionResponse] = DeveloperPreview.instance.transactions
    @Published var searchText: String = ""
    
    var searchedTransactions: [TransactionResponse] {
        guard !searchText.isEmpty else {
            return transactionList
        }
//        TODO: Make an API call to search endpoint. Use debounce
        return []
        
    }
    
}
