//
//  TransactionList.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 10/30/23.
//

import SwiftUI

struct TransactionList: View {
    
    let transactionList: [TransactionResponse]
    let onTransactionListItemClicked: (TransactionResponse) -> Void
    var isLoading: Bool = false
    
    var body: some View {
        
        let groupedTransactions = Helper.groupTransactionsByDate(transactionList: transactionList)
        
        ZStack {
            if isLoading {
                    List {
                        ForEach(0..<10, id: \.self) { _ in
                            ShimmerTransactionListItem()
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.visible, edges: .all)

                        }
                        .background(Color.surfaceBackground)
                    }.listStyle(.plain)
            } else {
                List {
                    ForEach(groupedTransactions.keys.sorted().reversed()
                        .prefix(10), id: \.self) { dateKey in
                            Section {
                                ForEach(groupedTransactions[dateKey]!, id: \.self) { transactionResponse in
                                    TransactionListItem(transactionResponse: transactionResponse, onTransactionListItemClicked: {
                                        onTransactionListItemClicked(transactionResponse)
                                    })
                                    .listRowInsets(EdgeInsets())
                                    .listRowSeparator(.visible, edges: .all)
                                }.background(.surfaceBackground)
                                
                            } header: {
                                VStack {
                                    
                                    HStack {
                                        Text(dateKey)
                                            .foregroundStyle(Colors.HeadingTextColor)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                .padding(.leading, 12)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .background(Colors.SurfaceBackgroundColor)
                                
                            }.background(Colors.SurfaceBackgroundColor)
                        }
                    
                    
                }
                .listStyle(.plain)
            }
            
        }
        .background(.surfaceBackground)
        
    }
}

#Preview {
    TransactionList(
        transactionList: DeveloperPreview.instance.transactions,
        onTransactionListItemClicked: { transactionResponse in
            
        }
    )
}
