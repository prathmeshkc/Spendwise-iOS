//
//  DashboardScreen.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 10/28/23.
//

import SwiftUI

struct DashboardScreen: View {
    
    @StateObject var dashboardViewModel = DashboardViewModel()
    
    @State private var formType: FormType?
    
    init() {
        // Large Navigation Title
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        // Inline Navigation Title
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        
        //Search Bar Appearance
//        UISearchBar.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = .componentsBackground
//        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .surfaceBackground
//
//        UISearchTextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search your transactions", attributes: [.foregroundColor: Colors.HeadingTextColor])

    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading) {
                    
                    TotalBalanceCard(amountText: dashboardViewModel.totalBalanceText, currentTimeFrameText: TransactionFilters.Monthly.rawValue, onTransactionFilterClicked: { filter in
                    }).padding(.horizontal, 12)
                        .padding(.vertical, 8)
                    
                    HStack {
                        TotalIncomeExpenseCard(type: .INCOME, amountText: dashboardViewModel.totalIncomeText)
                        TotalIncomeExpenseCard(type: .EXPENSE, amountText: dashboardViewModel.totalExpenseText)
                    }
                    .padding([.leading, .trailing], 8)
                    .padding(.bottom, 10)
                    
                    HStack(alignment: .center) {
                        Text("Recent Transactions")
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .foregroundStyle(.detailsText)
                        
                        Spacer()
                        
                        NavigationLink {
                            AllTransactionsScreen()
                        } label: {
                            Label(
                                title: { Text("See All")
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                },
                                icon: { Image(systemName: "chevron.right") }
                            )
                            .labelStyle(.trailingIcon)
                            .foregroundStyle(.FAB)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 12)
                    
                    switch dashboardViewModel.resultState {
                            
                        case .loading:
                            TransactionList(transactionList: DeveloperPreview.instance.transactions, onTransactionListItemClicked: { _ in
                                
                            }, isLoading: true)
                            .padding(.top, -5)
                            
                        case .failed(let error):
                            //                            TODO: Make a custom error view
                            Text("Something went wrong with error \(error.localizedDescription)!").foregroundStyle(.detailsText)
                            
                        case .success(let content):
                            
                            TransactionList(transactionList: content) { transactionResponse in
                                formType = .update(transactionResponse)
                            }
                            .padding(.top, -5)
                    }
                    
                    
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
                .sheet(item: $formType, onDismiss: {
                    dashboardViewModel.getAllTransaction()
                } , content: { formType in
                    formType
                })
                
            }
            .navigationTitle(Text("Home"))
            .searchable(text: $dashboardViewModel.searchText, prompt: "Search your transactions")
            .background(.surfaceBackground)
        }
        .background(.surfaceBackground)
        
        
    }
}

#Preview {
    DashboardScreen()
}
