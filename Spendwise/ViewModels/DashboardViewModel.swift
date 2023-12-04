//
//  DashboardViewModel.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/10/23.
//

import Foundation
import Combine


class DashboardViewModel: ObservableObject {
    
    private let transactionRepository: TransactionRepository = TransactionRepositoryImpl()
    private let searchRepository: SearchRepository = SearchRepositoryImpl()
    
    @Published var totalIncomeText = 0.0
    
    @Published var totalExpenseText = 0.0
    
    @Published var totalBalanceText = 0.0
    
    @Published var searchText: String = ""
    
    @Published private(set) var resultState: APIResultState<[TransactionResponse]> = .loading
    var transactionList: [TransactionResponse] = [TransactionResponse]()
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        self.getAllTransaction()
        self.setupSearch()
    }
    
    func getAllTransaction() {
        self.resultState = .loading
        let (formattedStartDate, formattedEndDate) = Helper.getFirstAndLastDayOfCurrentMonthFormatted()
        
        let cancellable = self.transactionRepository
            .request(endpoint: .getAllTransactionBetweenDates(startDate: formattedStartDate, endDate: formattedEndDate))
            .sink { (res) in
                switch res {
                    case .failure(let error):
                        self.resultState = .failed(error: error)
                    case .finished:
                        self.resultState = .success(content: self.transactionList)
                }
            } receiveValue: { res in
                let amountSummary = Helper.calculateSummary(transactions: res)
                self.totalIncomeText = amountSummary.income
                self.totalExpenseText = amountSummary.expense
                self.totalBalanceText = amountSummary.balance
                
                self.transactionList = res
            }
        self.cancellableSet.insert(cancellable)
    }
    
    private func setupSearch() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                
                guard let self = self else { return }
                
                if searchText.isEmpty {
                    self.getAllTransaction()
                } else {
                    self.searchTransactions()
                }
            }
            .store(in: &cancellableSet)
    }
    
    private func searchTransactions() {
        self.resultState = .loading
        
        guard !searchText.isEmpty else {
            return
        }
        
        let cancellable = self.searchRepository.request(endpoint: .searchTransactionsByText(searchText: searchText))
            .sink { (res) in
                switch res {
                    case .failure(let error):
                        self.resultState = .failed(error: error)
                    case .finished:
                        self.resultState = .success(content: self.transactionList)
                }
            } receiveValue: { res in
                self.transactionList = res
                Logger.logMessage(message: "Search Transactions List -> \(self.transactionList)")
            }
        self.cancellableSet.insert(cancellable)
    }
}
