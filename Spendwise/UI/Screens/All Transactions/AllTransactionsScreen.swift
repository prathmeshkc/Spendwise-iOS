//
//  AllTransactionScreen.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 10/30/23.
//

import SwiftUI

struct AllTransactionsScreen: View {
    
    @StateObject var allTransactionVM = AllTransactionsViewModel()
    @EnvironmentObject var mainViewModel: MainViewModel
    var body: some View {
        Text("All Transactions")
    }
}

#Preview {
    AllTransactionsScreen()
}
