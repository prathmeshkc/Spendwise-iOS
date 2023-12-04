//
//  AddTransactionViewModel.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/10/23.
//

import Foundation
import Combine

class AddTransactionViewModel: ObservableObject {
    
    private let transactionRepository: TransactionRepository = TransactionRepositoryImpl()
    
    @Published var transactionType: TransactionType = TransactionType.EXPENSE
    @Published var transactionTitle: String = ""
    @Published var transactionAmount: String = ""
    @Published var transactionCategory: TransactionCategory = TransactionCategory.Miscellaneous
    @Published var transactionDate: Date = Date.now
    @Published var transactionNote: String = ""
    
    @Published var isTransactionTitleCriteriaValid = false
    @Published var isTransactionAmountCriteriaValid = false
    @Published var isTransactionNoteCriteriaValid = false
    @Published var isComplete = false
    
    @Published private(set) var resultState: APIResultState<String> = .loading
    var transactionCreationStatus: String = ""
    private var cancellableSet: Set<AnyCancellable> = []
    
    var transactionId: String?
    
    var isUpdating: Bool { transactionId != nil }
    
    init() {
        $transactionTitle.map { transactionTitle in
            return !transactionTitle.isEmpty && !Helper.containsOnlyWhitespace(transactionTitle)
        }
        .assign(to: \.isTransactionTitleCriteriaValid, on: self)
        .store(in: &cancellableSet)
        
        $transactionAmount.map { transactionAmount in
            let transactionAmountInDouble = Double(transactionAmount) ?? 0
            return !(transactionAmountInDouble <= 0)
        }
        .assign(to: \.isTransactionAmountCriteriaValid, on: self)
        .store(in: &cancellableSet)
        
        $transactionNote.map { transactionNote in
            return !Helper.containsOnlyWhitespace(transactionNote) || transactionNote.isEmpty
        }
        .assign(to: \.isTransactionNoteCriteriaValid, on: self)
        .store(in: &cancellableSet)
        
        Publishers.CombineLatest3($isTransactionTitleCriteriaValid, $isTransactionAmountCriteriaValid, $isTransactionNoteCriteriaValid)
            .map { isTransactionTitleCriteriaValid, isTransactionAmountCriteriaValid, isTransactionNoteCriteriaValid in
                
                return (isTransactionTitleCriteriaValid && isTransactionAmountCriteriaValid && isTransactionNoteCriteriaValid)
            }
            .assign(to: \.isComplete, on: self)
            .store(in: &cancellableSet)
    }
    
    init(transactionResponseToUpdate oldTransactionResponse: TransactionResponse) {
        transactionId = oldTransactionResponse.id
        transactionType = TransactionType.fromString(oldTransactionResponse.transactionType)
        transactionTitle = oldTransactionResponse.title
        transactionAmount = oldTransactionResponse.amount.description
        transactionCategory = TransactionCategory.fromString(oldTransactionResponse.category)
        transactionDate = Helper.stringToDate(oldTransactionResponse.transactionDate)
        transactionNote = oldTransactionResponse.note
        
        $transactionTitle.map { transactionTitle in
            return !transactionTitle.isEmpty && !Helper.containsOnlyWhitespace(transactionTitle)
        }
        .assign(to: \.isTransactionTitleCriteriaValid, on: self)
        .store(in: &cancellableSet)
        
        $transactionAmount.map { transactionAmount in
            let transactionAmountInDouble = Double(transactionAmount) ?? 0
            return !(transactionAmountInDouble <= 0)
        }
        .assign(to: \.isTransactionAmountCriteriaValid, on: self)
        .store(in: &cancellableSet)
        
        $transactionNote.map { transactionNote in
            return !Helper.containsOnlyWhitespace(transactionNote) || transactionNote.isEmpty
        }
        .assign(to: \.isTransactionNoteCriteriaValid, on: self)
        .store(in: &cancellableSet)
        
        Publishers.CombineLatest3($isTransactionTitleCriteriaValid, $isTransactionAmountCriteriaValid, $isTransactionNoteCriteriaValid)
            .map { isTransactionTitleCriteriaValid, isTransactionAmountCriteriaValid, isTransactionNoteCriteriaValid in
                
                return (isTransactionTitleCriteriaValid && isTransactionAmountCriteriaValid && isTransactionNoteCriteriaValid)
            }
            .assign(to: \.isComplete, on: self)
            .store(in: &cancellableSet)
    }
    
    
    
    
    func saveTransaction() {
        self.resultState = .loading
        
        let transactionRequest = TransactionRequest(title: transactionTitle, amount: Helper.trimLeadingZeros(from: Double(transactionAmount) ?? 0), transactionType: transactionType.rawValue, category: transactionCategory.rawValue, transactionDate: Helper.dateToString(transactionDate), note: transactionNote)
        
        let cancellable = self.transactionRepository.request(endpoint: .createTransaction(transactionRequest: transactionRequest))
            .sink { (res) in
                switch res {
                    case .failure(let error):
                        self.resultState = .failed(error: error)
                    case .finished:
                        self.resultState = .success(content: self.transactionCreationStatus)
                }
            } receiveValue: { res in
                self.transactionCreationStatus = res
            }
        self.cancellableSet.insert(cancellable)
        
    }
    
    func updateTransaction() {
        self.resultState = .loading
        
        guard let transactionId = transactionId else {
            return
        }
        
        let transactionRequest = TransactionRequest(title: transactionTitle, amount: Helper.trimLeadingZeros(from: Double(transactionAmount) ?? 0), transactionType: transactionType.rawValue, category: transactionCategory.rawValue, transactionDate: Helper.dateToString(transactionDate), note: transactionNote)
        
        let cancellable = self.transactionRepository.request(endpoint: .updateTransaction(transactionId: transactionId, transactionRequest: transactionRequest))
            .sink { (res) in
                switch res {
                    case .failure(let error):
                        self.resultState = .failed(error: error)
                    case .finished:
                        self.resultState = .success(content: self.transactionCreationStatus)
                }
            } receiveValue: { res in
                self.transactionCreationStatus = res
            }
        self.cancellableSet.insert(cancellable)
    }
    
}
