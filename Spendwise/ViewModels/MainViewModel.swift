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
import Firebase
import GoogleSignIn


class MainViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
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
    
    func signInWithGoogle(gidSignInResult: GIDSignInResult) async throws {
        
        
        
        let user = gidSignInResult.user
        guard let idToken = user.idToken else {return}
        
        let accessToken = user.accessToken
        
        let authCredential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
        
        do {
            let authResult = try await Auth.auth().signIn(with: authCredential)
            let user = authResult.user
            let tokenResult = try await user.getIDTokenResult(forcingRefresh: true)
            let token = tokenResult.token
            print("Token -> \(token)")
            let userId = tokenResult.claims["user_id"] as? String ?? ""
            
            //If userId not present in the firestore, user is registering else loging in
            let ifUserExists = try await checkIfUserExists(userId: userId)
            
            if !ifUserExists {
                let userEmail = user.email ?? ""
                self.insertUserRecord(userId: userId, email: userEmail)
            }
            
            DispatchQueue.main.async {
                UserDefaults.standard.set(token as String, forKey: "TOKEN")
                UserDefaults.standard.set(true, forKey: "EMAIL_VERIFICATION_STATUS")
                self.accessToken = UserDefaults.standard.string(forKey: "TOKEN")
                self.isEmailVerified = UserDefaults.standard.bool(forKey: "EMAIL_VERIFICATION_STATUS")
            }
            
        } catch {
            Logger.logMessage(message: "MainViewModel::signInWithGoogle -> Error: \(error)", logType: .error)
        }
    }
    
    
    private func insertUserRecord(userId: String, email: String) {
        
        let newUser = User(
            id: userId,
            email: email,
            joinedAt: Date().timeIntervalSince1970
        )
        
        
        self.db.collection("users")
            .document(userId)
            .setData(newUser.asDictionary())
    }
    
    private func checkIfUserExists(userId: String) async throws -> Bool {
        let documentRef = self.db.collection("users").document(userId)
        let document = try await documentRef.getDocument()
        return document.exists
    }
    
}


enum EmailNotVerifiedError: Error {
    case emailNotVerified
}
