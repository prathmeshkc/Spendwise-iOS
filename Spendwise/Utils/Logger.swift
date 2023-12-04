//
//  Logger.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/17/23.
//

import Foundation


enum LogType {
    case debug
    case info
    case error
}


class Logger {
    
    private init() {}
    
    static func logMessage(message: String, logType: LogType = .debug) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let timestamp = formatter.string(from: Date())
            
            var logPrefix = ""
            switch logType {
                case .debug: logPrefix = "[DEBUG]"
                case .info: logPrefix = "[INFO]"
                case .error: logPrefix = "[ERROR]"
            }
            
            print("\n\n\(timestamp) \(logPrefix) \(message)\n\n")
        }
}
