//
//  KeychainManager.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/26/23.
//

import Foundation


class TokenManager {
    
    
    static let shared = TokenManager()
    private init() {}
    
    //    MARK: Save token to the Keychain
    func saveToken(account: String, token: String) -> Bool {
        
        let query: [String : AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: token as AnyObject,
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            Logger.logMessage(message: "TokenManager::saveToken -> \(status)", logType: .error)
            return false
        } else if status != errSecSuccess {
            return false
        }
        
        print("Token saved...")
        return true
    }
    
    //    MARK: Get token from the Keychain
    func getToken(account: String) -> Data? {
        
        let query: [String : AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        print("Read Token Status - \(status)")
        
        if status == errSecSuccess {
            return result as? Data
        } else {
            Logger.logMessage(message: "TokenManager::getToken -> \(status)", logType: .error)
            return nil
        }
    }
    
    //    MARK: Delete token from the Keychain
    func deleteToken(account: String) -> Bool {
        
        let query: [String : AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account as AnyObject,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            return true
        }
        
        return false
        
    }
}

enum KeychainError: Error {
    case duplicateEntry
    case unknown(OSStatus)
}
