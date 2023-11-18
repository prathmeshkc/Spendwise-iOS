//
//  SpendwiseApp.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 10/19/23.
//

import SwiftUI
//TODO:Customize the appearance of the Tab items
@main
struct SpendwiseApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Group {
                    DashboardScreen()
                    .tabItem {
                        Label(
                            title: { Text("Dashboard") },
                            icon: {
                                Image(systemName: "house")
                            }
                        )
                    }
                    
                    AllTransactionsScreen()
                    .tabItem {
                        Label(
                            title: { Text("Transactions") },
                            icon: {
                                Image(systemName: "creditcard")
                            }
                        )
                    }
                }
                .toolbarBackground(Colors.ComponentsBackgroundColor, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            }
            
        }
        
    }
}
