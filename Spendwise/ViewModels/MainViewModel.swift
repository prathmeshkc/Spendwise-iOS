//
//  SpendwiseViewModel.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/10/23.
//

/**
 Also works as an AuthViewModel
 */


import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class MainViewModel: ObservableObject {
    
    @Published var accessToken: String? = nil
    @Published var isEmailVerified: Bool = false
    @Published var sendVerifyEventToLoginScreen: Bool = false
    
    init() {
        self.accessToken = UserDefaults.standard.string(forKey: "TOKEN")
        self.isEmailVerified = UserDefaults.standard.bool(forKey: "EMAIL_VERIFICATION_STATUS")
    }
    
    
    func registerUserWithEmailPassword(email: String, password: String) async throws {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = authResult.user
            let tokenResult = try await user.getIDTokenResult(forcingRefresh: true)
            let token = tokenResult.token
            let userId = tokenResult.claims["user_id"] as? String ?? ""
            
            try await user.sendEmailVerification()
            
            DispatchQueue.main.async {
                //                UserDefaults.standard.set(token as String, forKey: "TOKEN")
                //                self.accessToken = UserDefaults.standard.string(forKey: "TOKEN")
                self.sendVerifyEventToLoginScreen = true
            }
            
            //            Save user to a firestore document
            self.insertUserRecord(userId: userId, email: email)
            
            Logger.logMessage(message: "MainViewModel::registerUserWithEmailPassword -> token(\(token))\n\tuserId(\(userId))", logType: .info)
        } catch {
            Logger.logMessage(message: "MainViewModel::registerUserWithEmailPassword -> Error: \(error)", logType: .error)
        }
    }
    
    func loginUserWithEmailPassword(email: String, password: String) async throws {
        print("Trying to login User with email: \(email) and password: \(password)")
        
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = authResult.user
        let tokenResult = try await user.getIDTokenResult(forcingRefresh: true)
        let token = tokenResult.token
        let userId = tokenResult.claims["user_id"] as? String ?? ""
        
        //            check if the email is verified
        //            save the token only if the email is verified and save the email verification status
        if user.isEmailVerified {
            DispatchQueue.main.async {
                UserDefaults.standard.set(token as String, forKey: "TOKEN")
                UserDefaults.standard.set(true, forKey: "EMAIL_VERIFICATION_STATUS")
                self.accessToken = UserDefaults.standard.string(forKey: "TOKEN")
                self.isEmailVerified = UserDefaults.standard.bool(forKey: "EMAIL_VERIFICATION_STATUS")
            }
        } else {
            throw EmailNotVerifiedError.emailNotVerified
        }
        
        Logger.logMessage(message: "MainViewModel::loginUserWithEmailPassword -> token(\(token))\n\tuserId(\(userId))", logType: .info)
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                UserDefaults.standard.removeObject(forKey: "TOKEN")
                self.accessToken = nil
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    
    private func insertUserRecord(userId: String, email: String) {
        
        let newUser = User(
            id: userId,
            email: email,
            joinedAt: Date().timeIntervalSince1970
        )
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .setData(newUser.asDictionary())
    }
    
}


enum EmailNotVerifiedError: Error {
    case emailNotVerified
}
