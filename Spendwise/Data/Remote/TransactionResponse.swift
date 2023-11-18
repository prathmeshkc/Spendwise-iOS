//
//  TransactionResponse.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 10/26/23.
//

import Foundation

struct TransactionResponse: Decodable, Hashable, Identifiable {
    let transactionId: String
    let userId: String
    let title: String
    let amount: Double
    let transactionType: String
    let category: String
    let transactionDate: String
    let note: String
    var id: String {
        return transactionId
    }
}
