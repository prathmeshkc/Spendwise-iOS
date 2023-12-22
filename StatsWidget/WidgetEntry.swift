//
//  WidgetEntry.swift
//  StatsWidgetExtension
//
//  Created by Prathmesh Chaudhari on 12/21/23.
//

import Foundation
import WidgetKit

struct WidgetEntry: TimelineEntry {
    let date: Date
    let transactions: [TransactionResponse]
    
    static func mockWidgetEntry() -> WidgetEntry {
        return WidgetEntry(date: .now, transactions: DeveloperPreview.instance.transactions)
    }
    
}
