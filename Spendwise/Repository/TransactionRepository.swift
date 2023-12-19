//
//  TransactionRepository.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/30/23.
//

import Foundation
import Combine

protocol TransactionRepository {
    func request<T: Decodable>(endpoint: TransactionAPI) -> AnyPublisher<T, APIError>
}

struct TransactionRepositoryImpl: TransactionRepository {
    
    func request<T>(endpoint: TransactionAPI) -> AnyPublisher<T, APIError> where T : Decodable {
        let jsonDecoder = JSONDecoder()
        
        return URLSession.shared
            .dataTaskPublisher(for: endpoint.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { _ in .unknown }
            .flatMap { data, response -> AnyPublisher<T, APIError> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: .unknown)
                        .eraseToAnyPublisher()
                }
                
                if (200...299).contains(response.statusCode) {
                    Logger.logMessage(message: "TransactionRepositoryImpl::request -> Data: \(data)")
                    return Just(data)
                        .decode(type: T.self, decoder: jsonDecoder)
                        .mapError {_ in .decodingError}
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: .errorCode(response.statusCode))
                        .eraseToAnyPublisher()
                }
                
            }.eraseToAnyPublisher()
    }
    
}
