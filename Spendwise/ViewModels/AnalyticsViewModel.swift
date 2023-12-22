//
//  AnalyticsViewModel.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 12/5/23.
//

import Foundation
import Combine

class AnalyticsViewModel: ObservableObject {
    
    private let transactionRepository: TransactionRepository = TransactionRepositoryImpl()
    
    @Published var startDate: Date = .now.startOfMonth
    @Published var endDate: Date = .now.endOfMonth
    
    @Published var chartType: ChartType = .Donut
    
    @Published private(set) var resultState: APIResultState<[TransactionResponse]> = .loading
    private var expenseTransactionList: [TransactionResponse] = [TransactionResponse]()
    var expenditurePercentageByCategory: [ExpenditureByCategory] = [ExpenditureByCategory]()
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        let (formattedStartDate, formattedEndDate) = Helper.getFirstAndLastDayOfCurrentMonthFormatted()
        getAllTransaction(startDate: formattedStartDate, endDate: formattedEndDate)
    }
    
    
    func getAllTransaction(startDate: String, endDate: String) {
        self.resultState = .loading
        
        let cancellable = self.transactionRepository
            .request(endpoint: .getAllTransactionBetweenDates(startDate: startDate, endDate: endDate))
            .sink { (res) in
                switch res {
                    case .failure(let error):
                        self.resultState = .failed(error: error)
                    case .finished:
                        self.resultState = .success(content: self.expenseTransactionList)
                }
            } receiveValue: { res in
                self.expenditurePercentageByCategory = Helper.calculateExpenditurePercentageByCategory(from: res)
            }
        self.cancellableSet.insert(cancellable)
    }
    
}
