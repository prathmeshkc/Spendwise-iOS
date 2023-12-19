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
    
    @State var showFilterView: Bool = false
    
    @State private var formType: FormType?
    
    init() {
        // Large Navigation Title
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        // Inline Navigation Title
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    showFilterView = true
                }, label: {
                    Text("\(Helper.dateToString(allTransactionVM.startDate)) - \(Helper.dateToString(allTransactionVM.endDate))")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.gray)
                })
                .hSpacing(alignment: .leading)
                .padding(12)
                .opacity(allTransactionVM.searchText.isEmpty ? 1 : 0)
                
                switch allTransactionVM.resultState {
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
                            self.allTransactionVM.getAllTransaction(startDate: allTransactionVM.startDate.toString, endDate: allTransactionVM.endDate.toString)
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
                                    allTransactionVM.deleteTransaction(transactionId: transactionId)
                                }
                            )
                            .padding(.top, -5)
                            .sheet(item: $formType, onDismiss: {
                                allTransactionVM.getAllTransaction(startDate: allTransactionVM.startDate.toString, endDate: allTransactionVM.endDate.toString)
                            } , content: { formType in
                                formType
                            })
                            .refreshable {
                                allTransactionVM.getAllTransaction(startDate: allTransactionVM.startDate.toString, endDate: allTransactionVM.endDate.toString)
                            }
                        }
                }
                
                Spacer()
            }
            .background(.surfaceBackground)
            .blur(radius: showFilterView ? 8 : 0)
            .disabled(showFilterView)
        }
        .overlay {
            if showFilterView {
                DateFilterView(start: $allTransactionVM.startDate, end: $allTransactionVM.endDate, onSubmit: { start, end in
                    allTransactionVM.startDate = start
                    allTransactionVM.endDate = end
                    showFilterView = false
                    allTransactionVM.getAllTransaction(startDate: allTransactionVM.startDate.toString, endDate: allTransactionVM.endDate.toString)
                }, onClose: {
                    showFilterView = false
                })
                .transition(.move(edge: .leading))
            }
        }
        .animation(.snappy, value: showFilterView)
        .navigationTitle(Text("Transactions"))
        .searchable(text: $allTransactionVM.searchText, prompt: "Search your transactions")
        .background(.surfaceBackground)
    }
}

#Preview {
    AllTransactionsScreen()
}
