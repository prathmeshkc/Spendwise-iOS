//
//  User.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 12/16/23.
//

import Foundation


struct User: Codable {
    let id: String
    let email: String
    let joinedAt: TimeInterval
}
