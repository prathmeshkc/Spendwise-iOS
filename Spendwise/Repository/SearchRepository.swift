//
//  SearchRepository.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 12/4/23.
//

import Foundation
import Combine

protocol SearchRepository {
    func request<T: Decodable>(endpoint: SearchAPI) -> AnyPublisher<T, APIError>
}

//TODO: Add refreshTokenAndRetry

struct SearchRepositoryImpl: SearchRepository {
    
    func request<T>(endpoint: SearchAPI) -> AnyPublisher<T, APIError> where T : Decodable {
        let jsonDecoder = JSONDecoder()

        return URLSession.shared.dataTaskPublisher(for: endpoint.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { _ in .unknown }
            .flatMap { data, response ->
                AnyPublisher<T, APIError> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: .unknown)
                        .eraseToAnyPublisher()
                }
                
                if (200...299).contains(response.statusCode) {
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
