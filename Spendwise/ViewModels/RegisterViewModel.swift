//
//  RegisterViewModel.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/10/23.
//

import Foundation
import Combine
import FirebaseAuth


class RegisterViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var isEmailCriteriaValid = false
    @Published var isPasswordCriteriaValid = false
    @Published var isPasswordConfirmValid = false
    @Published var canSubmit = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])")
    
    
    init() {
        
        $email.map { email in
            return self.emailPredicate.evaluate(with: email)
        }
        .assign(to: \.isEmailCriteriaValid, on: self)
        .store(in: &cancellableSet)
        
        $password.map { password in
            return !password.isEmpty && password.count > 4
        }
        .assign(to: \.isPasswordCriteriaValid, on: self)
        .store(in: &cancellableSet)
        
        Publishers.CombineLatest($password, $confirmPassword)
            .map { password, confirmPw in
                return password == confirmPw
            }
            .assign(to: \.isPasswordConfirmValid, on: self)
            .store(in: &cancellableSet)
        
        Publishers.CombineLatest3($isEmailCriteriaValid, $isPasswordCriteriaValid, $isPasswordConfirmValid)
            .map { isEmailCriteriaValid, isPasswordCriteriaValid, isPasswordConfirmValid in
                return (isEmailCriteriaValid && isPasswordCriteriaValid && isPasswordConfirmValid)
            }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellableSet)
    }
   
    var emailPrompt: String {
        isEmailCriteriaValid ?
        ""
        :
        "Enter a valid email address"
    }
    
    var passwordPrompt: String {
        isPasswordCriteriaValid ?
        ""
        :
        "Password should be atleast 5 characters!"
    }
    
    var confirmPwPrompt: String {
        isPasswordConfirmValid ?
        ""
        :
        "Password fields to not match"
    }
    
    
    
}
