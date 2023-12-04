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

@MainActor
class MainViewModel: ObservableObject {
    
    @Published var accessToken: String? = nil
    //    @Published var isEmailVerified: Bool = UserDefaults.standard.bool(forKey: "EMAIL_VERIFICATION_STATUS")
    
    
    init() {
        self.accessToken = UserDefaults.standard.string(forKey: "TOKEN")
    }
    
    
    func registerUserWithEmailPassword(email: String, password: String) async throws {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = authResult.user
            let tokenResult = try await user.getIDTokenResult(forcingRefresh: true)
            let token = tokenResult.token
            let userId = tokenResult.claims["user_id"] as? String ?? ""
            
            //            try await user.sendEmailVerification()
            
            DispatchQueue.main.async {
                UserDefaults.standard.set(token as String, forKey: "TOKEN")
                self.accessToken = UserDefaults.standard.string(forKey: "TOKEN")
            }
            
            Logger.logMessage(message: "MainViewModel::registerUserWithEmailPassword -> token(\(token))\n\tuserId(\(userId))", logType: .info)
        } catch {
            Logger.logMessage(message: "MainViewModel::registerUserWithEmailPassword -> Error: \(error)", logType: .error)
        }
    }
    
    func loginUserWithEmailPassword(email: String, password: String) async throws {
        print("Trying to login User with email: \(email) and password: \(password)")
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = authResult.user
            let tokenResult = try await user.getIDTokenResult(forcingRefresh: true)
            let token = tokenResult.token
            let userId = tokenResult.claims["user_id"] as? String ?? ""
//            check if the email is verified
//            let isEmailVerified = user.isEmailVerified
//            save the token only if the email is verified and save the email verification status
            
            DispatchQueue.main.async {
                UserDefaults.standard.set(token as String, forKey: "TOKEN")
                self.accessToken = UserDefaults.standard.string(forKey: "TOKEN")
                //                self.isTokenAvailable = true
            }
            
            Logger.logMessage(message: "MainViewModel::loginUserWithEmailPassword -> token(\(token))\n\tuserId(\(userId))", logType: .info)
        } catch {
            Logger.logMessage(message: "MainViewModel::loginUserWithEmailPassword -> Error: \(error)", logType: .error)
        }
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
    
}
