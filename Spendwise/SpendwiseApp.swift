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
    @StateObject var networkManager = NetworkManager()
    
    @State private var showNoConnectionSheet = false
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(mainViewModel)
                .sheet(isPresented: $showNoConnectionSheet, content: {
                    NoInternetSheet()
                        .interactiveDismissDisabled()
                })
                .onReceive(networkManager.$isConnected, perform: { connected in
                    if !connected {
                        showNoConnectionSheet = true
                    } else {
                        showNoConnectionSheet = false
                    }
                })
                
        }
        
    }
}
