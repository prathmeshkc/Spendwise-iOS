//
//  Result.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/28/23.
//

import Foundation

enum APIResultState<T: Decodable> {
    case loading
    case failed(error: Error)
    case success(content: T)
}


enum APIError: Error {
    case decodingError
    case errorCode(Int)
    case unknown
}


extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .decodingError:
                return "Failed to decode the error from the service"
            case .errorCode(let code):
                return "Status Code - \(code)"
            case .unknown:
                return "Unknwon Error Occured!"
        }
    }
}
