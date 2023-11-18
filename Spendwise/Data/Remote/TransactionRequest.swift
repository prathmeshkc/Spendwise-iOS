//
//  TransactionRequest.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 10/26/23.
//

import Foundation


struct TransactionRequest: Encodable {
    let title: String
    let amount: Double
    let transactionType: String
    let category: String
    let transactionDate: String
    let note: String
}
