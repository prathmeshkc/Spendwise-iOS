//
//  ProfileViewModel.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 12/16/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    
    @Published var user: User? = nil
    
    init() {
        fetchUser()
    }
    
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument {
            snapshot,
            error in
            guard let data = snapshot?.data(),
                  error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.user = User(
                    id: data["id"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    joinedAt: data["joinedAt"] as? TimeInterval ?? 0
                )
            }
        }
    }
    
    
    
    
}
