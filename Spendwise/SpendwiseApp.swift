//
//  SpendwiseApp.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 10/19/23.
//

import SwiftUI
import Firebase

@main
struct SpendwiseApp: App {
    
    @StateObject var mainViewModel: MainViewModel = MainViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(mainViewModel)
        }
        
    }
}
