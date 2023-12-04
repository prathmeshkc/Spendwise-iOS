//
//  SpendwiseAPI.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/30/23.
//

import Foundation


enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}


protocol APIBuilder {
    var baseUrl: URL { get }
    var urlRequest: URLRequest { get }
    
}

enum TransactionAPI {
    case createTransaction(transactionRequest: TransactionRequest)
    case getAllTransaction
    case updateTransaction(transactionId: String, transactionRequest: TransactionRequest)
    case deleteTransaction(transactionId: String)
    case getAllTransactionBetweenDates(startDate: String, endDate: String)
    
}

enum SearchAPI {
    case searchTransactionsByText(searchText: String)
//    case searchTransactionByTypeAndText(searchText: String, transactionType: String)
}


extension TransactionAPI: APIBuilder {
    
    var baseUrl: URL {
        return URL(string: BASE_URL + "transaction")!
    }
    
    var urlRequest: URLRequest {
        
        switch self {
            case .createTransaction(let transactionRequest):
                
                guard let transactionRequestJSONData = try? JSONEncoder().encode(transactionRequest) else {
                    Logger.logMessage(message: "TransactionAPI::createTransaction -> Cannot encode transactionRequest", logType: .error)
                    return URLRequest(url: URL(string: "")!)
                }
                
                var urlRequest = URLRequest(url: self.baseUrl)
                urlRequest.httpMethod = HTTPMethod.POST.rawValue
                urlRequest.httpBody = transactionRequestJSONData
                
                guard let token = UserDefaults.standard.string(forKey: "TOKEN") else {
                    Logger.logMessage(message: "No token found!", logType: .error)
                    return URLRequest(url: URL(string: "")!)
                }
                
                Logger.logMessage(message: "TransactionAPI::createTransaction -> TOKEN - \(token)")
                
                urlRequest.setValue( "Bearer " + token, forHTTPHeaderField: "Authorization")
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                Logger.logMessage(message: "TransactionAPI::createTransaction -> \(urlRequest)", logType: .debug)
                return urlRequest
                
            case .getAllTransaction:
                
                var urlRequest = URLRequest(url: self.baseUrl)
                urlRequest.httpMethod = HTTPMethod.GET.rawValue
                guard let token = UserDefaults.standard.string(forKey: "TOKEN") else {
                    Logger.logMessage(message: "No token found!", logType: .error)
                    return URLRequest(url: URL(string: "")!)
                }
                
                Logger.logMessage(message: "TransactionAPI::getAllTransaction -> TOKEN - \(token)")
                
                urlRequest.setValue( "Bearer " + token, forHTTPHeaderField: "Authorization")
                Logger.logMessage(message: "TransactionAPI::getAllTransaction -> \(urlRequest)", logType: .debug)
                return urlRequest
                
            case .updateTransaction(let transactionId, let transactionRequest):
                
                guard let transactionRequestJSONData = try? JSONEncoder().encode(transactionRequest) else {
                    Logger.logMessage(message: "TransactionAPI::updateTransaction -> Cannot encode transactionRequest", logType: .error)
                    return URLRequest(url: URL(string: "")!)
                }
                
                let urlComponents = URLComponents(url: self.baseUrl.appending(path: transactionId), resolvingAgainstBaseURL: true)
                
                guard let url = urlComponents?.url else {
                    Logger.logMessage(message: "TransactionAPI::updateTransaction -> Cannot get URL from URL Components!", logType: .error)
                    return URLRequest(url: URL(string: "")!)
                }
                
                var urlRequest = URLRequest(url: url)
                
                urlRequest.httpMethod = HTTPMethod.PUT.rawValue
                urlRequest.httpBody = transactionRequestJSONData
                
                guard let token = UserDefaults.standard.string(forKey: "TOKEN") else {
                    Logger.logMessage(message: "TransactionAPI::updateTransaction -> No token found!", logType: .error)
                    return URLRequest(url: URL(string: "")!)
                }
                
                Logger.logMessage(message: "TransactionAPI::updateTransaction -> TOKEN - \(token)")
                
                urlRequest.setValue( "Bearer " + token, forHTTPHeaderField: "Authorization")
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                Logger.logMessage(message: "TransactionAPI::updateTransaction -> URL - \(urlRequest)")
                
                return urlRequest
                
            case .deleteTransaction(let transactionId):
                
                let urlComponents = URLComponents(url: self.baseUrl.appending(path: transactionId), resolvingAgainstBaseURL: true)
                
                guard let url = urlComponents?.url else {
                    Logger.logMessage(message: "TransactionAPI::deleteTransaction -> Cannot get URL from URL Components!", logType: .error)
                    return URLRequest(url: URL(string: "")!)
                }
                
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = HTTPMethod.DELETE.rawValue
                
                guard let token = UserDefaults.standard.string(forKey: "TOKEN") else {
                    Logger.logMessage(message: "TransactionAPI::deleteTransaction -> No token found!", logType: .error)
                    return URLRequest(url: URL(string: "")!)
                }
                
                Logger.logMessage(message: "TransactionAPI::deleteTransaction -> TOKEN - \(token)")
                urlRequest.setValue( "Bearer " + token, forHTTPHeaderField: "Authorization")
                
                Logger.logMessage(message: "TransactionAPI::deleteTransaction -> URL - \(urlRequest)")
                
                return urlRequest
                
            case .getAllTransactionBetweenDates(let startDate, let endDate):
                
                var urlComponents = URLComponents(url: self.baseUrl.appending(path: "filter"), resolvingAgainstBaseURL: true)
                
                
                let queryItemStartDate = URLQueryItem(name: "startDate", value: startDate)
                let queryItemEndDate = URLQueryItem(name: "endDate", value: endDate)

                urlComponents?.queryItems = [queryItemStartDate, queryItemEndDate]
                
                guard let url = urlComponents?.url else {
                    Logger.logMessage(message: "TransactionAPI::getAllTransactionBetweenDates -> Cannot get URL from URL Components!", logType: .error)
                    return URLRequest(url: URL(string: "")!)
                }
                
                
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = HTTPMethod.GET.rawValue
                
                guard let token = UserDefaults.standard.string(forKey: "TOKEN") else {
                    Logger.logMessage(message: "TransactionAPI::getAllTransactionBetweenDates -> No token found!", logType: .error)
                    return URLRequest(url: URL(string: "")!)
                }
                
                Logger.logMessage(message: "TransactionAPI::getAllTransactionBetweenDates -> TOKEN - \(token)")
                
                urlRequest.setValue( "Bearer " + token, forHTTPHeaderField: "Authorization")
                
                Logger.logMessage(message: "TransactionAPI::getAllTransactionBetweenDates -> URL - \(urlRequest)")
                return urlRequest
        }
    }
}


extension SearchAPI: APIBuilder {
    var baseUrl: URL {
        return URL(string: BASE_URL + "transaction/search")!
    }
    
    var urlRequest: URLRequest {
        switch self {
            case .searchTransactionsByText(let searchText):
                
                var urlComponents = URLComponents(url: self.baseUrl, resolvingAgainstBaseURL: true)
                
                let queryItemSearchText = URLQueryItem(name: "searchQuery", value: searchText)
                
                urlComponents?.queryItems = [queryItemSearchText]
                
                guard let url = urlComponents?.url else {
                    Logger.logMessage(message: "SearchAPI::searchTransactionsByText -> Cannot get URL from URL Components!", logType: .error)
                    return URLRequest(url: URL(string: "")!)
                }
                
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = HTTPMethod.GET.rawValue
                
                guard let token = UserDefaults.standard.string(forKey: "TOKEN") else {
                    Logger.logMessage(message: "SearchAPI::searchTransactionsByText -> No token found!", logType: .error)
                    return URLRequest(url: URL(string: "")!)
                }
                
                Logger.logMessage(message: "SearchAPI::searchTransactionsByText -> TOKEN - \(token)")
                
                urlRequest.setValue( "Bearer " + token, forHTTPHeaderField: "Authorization")
                
                Logger.logMessage(message: "SearchAPI::searchTransactionsByText -> URL - \(urlRequest)")
                return urlRequest
        }
    }
    
    
}
