//
//  SpendwiseApp.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 10/19/23.
//

import SwiftUI
import FirebaseCore
import Firebase
import GoogleSignIn

@main
struct SpendwiseApp: App {
    
//    Register app delegate for the Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var mainViewModel: MainViewModel = MainViewModel()
    @StateObject var networkManager = NetworkManager()
    
    @State private var showNoConnectionSheet = false

//    init() {
//        FirebaseApp.configure()
//    }

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


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    //The method should call the handleURL method of the GIDSignIn instance, which will properly handle the URL that your application receives at the end of the authentication process.
    
    @available(iOS 9.0, *)
    //it asks the delegate to open the resource specified by the URL
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
