//
//  AllTransactionsViewModel.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/10/23.
//

import Foundation
import FirebaseAuth
import Combine

class AllTransactionsViewModel: ObservableObject {
    
    private let transactionRepository: TransactionRepository = TransactionRepositoryImpl()
    private let searchRepository: SearchRepository = SearchRepositoryImpl()
    
    @Published var startDate: Date = .now.startOfMonth
    @Published var endDate: Date = .now.endOfMonth
    
    @Published private(set) var resultState: APIResultState<[TransactionResponse]> = .loading
    
    @Published var searchText: String = ""
    
    var transactionList: [TransactionResponse] = [TransactionResponse]()
    
    var transactionDeletionStatus: String = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        let (formattedStartDate, formattedEndDate) = Helper.getFirstAndLastDayOfCurrentMonthFormatted()
        getAllTransaction(startDate: formattedStartDate, endDate: formattedEndDate)
        
        self.setupSearch()
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
                        self.resultState = .success(content: self.transactionList)
                }
            } receiveValue: { res in
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
                    self.getAllTransaction(startDate: startDate.toString, endDate: endDate.toString)
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
                Logger.logMessage(message: "AllTransactionsViewModel::searchTransactions -> Search Transactions List -> \(self.transactionList)")
            }
        self.cancellableSet.insert(cancellable)
    }
    
    func deleteTransaction(transactionId: String) {
        let cancellable = self.transactionRepository.request(endpoint: .deleteTransaction(transactionId: transactionId))
            .sink { [weak self] (res) in
                
                guard let self = self else { return }
                
                switch res {
                    case .failure(let error):
///                        This will throw decoding error because it cannot decode Object sent from the backend
                        //                        TODO: Show error response like a toast or something
                        Logger.logMessage(message: "AllTransactionsViewModel::deleteTransaction -> \(error)", logType: .error)
                        
                    case .finished:

                        Logger.logMessage(message: "AllTransactionsViewModel::deleteTransaction -> Transaction Deleted Successfully!", logType: .info)
                        
                }
                
                self.getAllTransaction(startDate: startDate.toString, endDate: endDate.toString)
            } receiveValue: { res in
                self.transactionDeletionStatus = res
                
            }
        
        self.cancellableSet.insert(cancellable)
        
    }
}
