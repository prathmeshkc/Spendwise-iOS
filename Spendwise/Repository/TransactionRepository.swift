//
//  TransactionRepository.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/30/23.
//

import Foundation
import Combine
import FirebaseAuth

protocol TransactionRepository {
    func request<T: Decodable>(endpoint: TransactionAPI) -> AnyPublisher<T, APIError>
    func requestWithClosure<T: Decodable>(endpoint: TransactionAPI, completion: @escaping (Result<T, APIError>) -> Void)
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
                } else if response.statusCode == 401 {
                    return refreshTokenAndRetry(endpoint: endpoint, decoder: jsonDecoder)
                } else {
                    return Fail(error: .errorCode(response.statusCode))
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
    
    func requestWithClosure<T>(endpoint: TransactionAPI, completion: @escaping (Result<T, APIError>) -> Void) where T: Decodable {
        
        let jsonDecoder = JSONDecoder()
        
        URLSession.shared.dataTask(with: endpoint.urlRequest) { data, response, error in
            guard error != nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknown))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.errorCode(httpResponse.statusCode)))
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try jsonDecoder.decode(T.self, from: data)
                    Logger.logMessage(message: "TransactionRepositoryImpl::requestWithClosure -> Data: \(decodedData)")
                    completion(.success(decodedData))
                } catch {
                    Logger.logMessage(message: "TransactionRepositoryImpl::requestWithClosure -> Failed Response")
                    completion(.failure(.decodingError))
                }
            } else {
                completion(.failure(.unknown))
            }
        }.resume()
    }
    
    
    
    public func refreshTokenAndRetry<T>(endpoint: TransactionAPI, decoder: JSONDecoder) -> AnyPublisher<T, APIError> where T: Decodable {
        return Future { promise in
            Task {
                do {
                    // Fetch and save new token from Firebase
                    try await fetchAndSaveIdToken()
                    
                    // Retry the failed request with the new token
                    let (data, response) = try await URLSession.shared.data(for: endpoint.urlRequest)
                    guard let httpResponse = response as? HTTPURLResponse else {
                        DispatchQueue.main.async {
                            promise(.failure(APIError.unknown))
                        }
                        return
                    }
                    
                    if (200...299).contains(httpResponse.statusCode) {
                        Logger.logMessage(message: "TransactionRepositoryImpl::refreshTokenAndRetry -> Data: \(data)")
                        let decodedData = try decoder.decode(T.self, from: data)
                        DispatchQueue.main.async {
                            promise(.success(decodedData))
                        }
                    } else {
                        DispatchQueue.main.async {
                            promise(.failure(APIError.errorCode(httpResponse.statusCode)))
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        promise(.failure(APIError.unknown))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchAndSaveIdToken() async throws {
        do {
            
            let tokenResult = try await Auth.auth().currentUser?.getIDTokenResult(forcingRefresh: true)
            let token = tokenResult?.token ?? ""
            DispatchQueue.main.async {
                UserDefaults.standard.set(token as String, forKey: "TOKEN")
            }
            
        } catch let error{
            debugPrint(error.localizedDescription)
            throw error
        }
    }
}
