//
//  DashboardScreen.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 10/28/23.
//

import SwiftUI
//TODO: Calculate income, expense, balance from the list
struct DashboardScreen: View {
    
    @StateObject var dashboardViewModel = DashboardViewModel()
    
    @State private var formType: FormType?
    
    init() {
        // Large Navigation Title
          UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
          // Inline Navigation Title
          UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        
       NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading) {
                    
                    TotalBalanceCard(amountText: -1807.123456, currentTimeFrameText: TransactionFilters.Monthly.rawValue, onTransactionFilterClicked: { filter in
                    }).padding([.vertical, .horizontal], 12)
                    
                    HStack {
                        TotalIncomeExpenseCard(type: .INCOME, amountText: 3570.00)
                        TotalIncomeExpenseCard(type: .EXPENSE, amountText: 1767.00)
                    }
                    .padding([.leading, .trailing], 12)
                    .padding(.bottom, 10)
                    
                    HStack(alignment: .center) {
                        Text("Recent Transaction")
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .foregroundStyle(.detailsText)
                        
                        Spacer()
                        
                        Button(action: {
                            //TODO: Navigate to All Transaction Screen
                        }, label: {
                            Label(
                                title: { Text("See All")
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                },
                                icon: { Image(systemName: "chevron.right") }
                            )
                            .labelStyle(.trailingIcon)
                            .foregroundStyle(.FAB)
                        })
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 12)
                    
                    
                    //TODO: If isLoading, show shimmer, else show TransactionList. Do it by making an extension on the view struct and creating a private
                    TransactionList(transactionList: dashboardViewModel.transactionList) { transactionResponse in
                        formType = .update(transactionResponse)
                    }
                    .padding(.top, -5)
                }
                
                
                Button(action: {
                    formType = .new
                    
                }, label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.white)
                        .font(.title.weight(.semibold))
                        .padding(14)
                        .background(.FAB)
                        .clipShape(.circle)
                        .shadow(radius: 4, x: 0, y: 4)
                })
                .padding(.trailing, 30)
                .padding(.bottom, 50)
                .buttonStyle(GrowingButton())
                .sheet(item: $formType, content: { formType in
                    formType
                })
            }
            .navigationTitle(Text("Home"))
            .background(.surfaceBackground)
            .padding(.top, 0)
            .searchable(text: $dashboardViewModel.searchText, prompt: "Search your transactions")
        }
       .background(.surfaceBackground)
    }
}

#Preview {
    DashboardScreen()
}
