//
//  Provider.swift
//  StatsWidgetExtension
//
//  Created by Prathmesh Chaudhari on 12/21/23.
//

import WidgetKit

struct Provider: TimelineProvider {
    
    let transactionRepository: TransactionRepository = TransactionRepositoryImpl()
    typealias Entry = WidgetEntry
    
    func placeholder(in context: Context) -> WidgetEntry {
        return WidgetEntry.mockWidgetEntry()
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry.mockWidgetEntry()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
      
        Logger.logMessage(message: "Provider::getTimeline")
        let (formattedStartDate, formattedEndDate) = Helper.getFirstAndLastDayOfCurrentMonthFormatted()
        
        transactionRepository.requestWithClosure(endpoint: .getAllTransactionBetweenDates(startDate: formattedStartDate, endDate: formattedEndDate)) { (result: Result<[TransactionResponse], APIError>) in
            
            switch result {
                case .success(let transactions):
                    // Process 'transactions' here
                    // Populate 'entries' based on 'transactions' or any other data
                    Logger.logMessage(message: "Provider::getTimeline -> Success Response \(transactions)", logType: .info)
                    
                    let entry = WidgetEntry(date: .now, transactions: transactions)
                    let timeline = Timeline(entries: [entry], policy: .atEnd)
                    completion(timeline)
                
                case .failure(let error):
                    // Handle the error from the transaction repository request
                    print("Error fetching transactions: \(error)")
                    Logger.logMessage(message: "Provider::getTimeline -> Failed Response \(error)", logType: .error)
                    // You might want to create a default timeline or handle errors accordingly
                    let defaultEntry = WidgetEntry.mockWidgetEntry() // Replace with your default widget entry
                    let defaultTimeline = Timeline(entries: [defaultEntry], policy: .atEnd)
                    completion(defaultTimeline)
            }
        }
    }
}

