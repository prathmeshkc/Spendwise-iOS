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
    
    
    var body: some View {
        
        let groupedTransactions = Helper.groupTransactionsByDate(transactionList: transactionList)
        
        ZStack {
            List {
                
                ForEach(groupedTransactions.keys.sorted().prefix(10), id: \.self) { dateKey in
                    Section {
                        ForEach(groupedTransactions[dateKey]!, id: \.self) { transactionResponse in
                            TransactionListItem(transactionResponse: transactionResponse, onTransactionListItemClicked: {
                                onTransactionListItemClicked(transactionResponse)
                            })
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden, edges: .all)
                        }.background(.surfaceBackground)
                    } header: {
                        VStack {
                            Spacer()
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
