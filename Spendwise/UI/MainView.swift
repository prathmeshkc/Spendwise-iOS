//
//  MainView.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/23/23.
//

import SwiftUI
import WidgetKit

struct MainView: View {
    
    enum Tab {
        case dashboard, analytics, profile
    }
    
    @EnvironmentObject var mainViewModel: MainViewModel
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    @State private var selectedTab: Tab = .dashboard
    
    var body: some View {
        
        ZStack {
            if mainViewModel.accessToken != nil && mainViewModel.isEmailVerified  {
                
                TabView(selection: $selectedTab) {
                    Group {
                        DashboardScreen()
                            .tabItem {
                                Label {
                                    Text("Dashboard")
                                } icon: {
                                    Image(systemName: "house")
                                }
                            }
                            .tag(Tab.dashboard)
                        
                        AnalyticsScreen()
                            .tabItem {
                                Label {
                                    Text("Analytics")
                                } icon: {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                }
                                
                            }
                            .tag(Tab.analytics)
                        
                        ProfileScreen()
                            .tabItem {
                                Label {
                                    Text("Profile")
                                } icon: {
                                    Image(systemName: "person.crop.circle")
                                }
                            }
                            .tag(Tab.profile)
                    }
                    .toolbarBackground(Colors.ComponentsBackgroundColor, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                }
                .sheet(isPresented: $isFirstTime) {
                    IntroScreen()
                        .interactiveDismissDisabled()
                }
                .onAppear {
                    WidgetCenter.shared.reloadAllTimelines()
                }
            } else {
                RegisterScreen()
                    .transition(.opacity)
            }
        }.animation(.smooth, value: mainViewModel.accessToken)
        
    }
}
