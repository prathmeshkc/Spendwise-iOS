//
//  MainView.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/23/23.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    
    var body: some View {
        
        ZStack {
            if mainViewModel.accessToken != nil {
                
                TabView {
                    Group {
                        DashboardScreen()
                            .tabItem {
                                Label {
                                    Text("Dashboard")
                                } icon: {
                                    Image(systemName: "house")
                                }
                            }
                        
                        AnalyticsScreen()
                            .tabItem {
                                Label {
                                    Text("Analytics")
                                } icon: {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                }
                                
                            }
                        
                        ProfileScreen()
                            .tabItem {
                                Label {
                                    Text("Profile")
                                } icon: {
                                    Image(systemName: "person.crop.circle")
                                }
                            }
                    }
                    .toolbarBackground(Colors.ComponentsBackgroundColor, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                }
            } else {
                RegisterScreen()
                    .transition(.opacity)
            }
        }.animation(.smooth, value: mainViewModel.accessToken)
        
    }
}
