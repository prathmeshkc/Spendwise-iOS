//
//  DashboardScreen.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 10/28/23.
//

import SwiftUI
import WidgetKit

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
                    
                    TotalBalanceCard(income: dashboardViewModel.totalIncomeText, expense: dashboardViewModel.totalExpenseText)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                    
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
                            ZStack {
                                List {
                                    ForEach(0..<7, id: \.self) { _ in
                                        ShimmerTransactionListItem()
                                            .listRowInsets(EdgeInsets())
                                            .listRowSeparator(.visible, edges: .all)
                                    }
                                    .background(Color.surfaceBackground)
                                }.listStyle(.plain)
                                    .padding(.top, -5)
                                    .padding(.horizontal)
                            }.background(.surfaceBackground)
                            
                        case .failed(let error):
                            ErrorView(error: error) {
                                self.dashboardViewModel.getAllTransaction()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand to cover entire screen
                            .background(Color.surfaceBackground.ignoresSafeArea())
                            .transition(.move(edge: .bottom))
                            
                        case .success(let content):
                            
                            if content.isEmpty {
                                LottieView(animation: .emptyList, loopMode: .loop)
                            } else {
                                TransactionList(
                                    transactionList: content,
                                    onTransactionListItemClicked: { transactionResponse in
                                        formType = .update(transactionResponse)
                                    },
                                    onTransactionListSwipedToDelete: { transactionId in
                                        dashboardViewModel.deleteTransaction(transactionId: transactionId)
                                        WidgetCenter.shared.reloadAllTimelines()
                                    },
                                    isLimited: true
                                )
                                .refreshable {
                                    dashboardViewModel.getAllTransaction()
                                }
                            }
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
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            
            Text("Home")
                .font(.title.bold())
                .foregroundStyle(.white)
            
            Spacer(minLength: 0)
            
            Button(action: {
                formType = .new
            }, label: {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
                    .font(.title.weight(.semibold))
                    .padding(12)
                    .background(.FAB)
                    .clipShape(.circle)
                    .shadow(radius: 4, x: 0, y: 4)
            })
            .buttonStyle(GrowingButton())
            .sheet(item: $formType, onDismiss: {
                dashboardViewModel.getAllTransaction()
            } , content: { formType in
                formType
            })
        }
        .padding(.bottom, 5)
        .padding(.horizontal, 12)
        //        .background {
        //            Rectangle()
        //                .fill(.ultraThinMaterial)
        //                .padding(.horizontal, -15)
        //                .padding(.top, -(safeArea.top + 15))
        //        }
    }
}

#Preview {
    DashboardScreen()
}
