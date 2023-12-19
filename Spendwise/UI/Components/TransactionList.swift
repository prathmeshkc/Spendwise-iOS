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
    let onTransactionListSwipedToDelete: ((String) -> Void)?
    var isLimited: Bool = false
    
    var body: some View {
        
        let groupedTransactions = Helper.groupTransactionsByDate(transactionList: transactionList)
        
        ZStack {
            List {
                ForEach(groupedTransactions.keys.sorted().reversed()
                    .prefix(isLimited ? 10 : groupedTransactions.keys.count), id: \.self) { dateKey in
                        Section {
                            ForEach(groupedTransactions[dateKey]!, id: \.self, content: {  transactionResponse in
                                TransactionListItem(transactionResponse: transactionResponse, onTransactionListItemClicked: {
                                    onTransactionListItemClicked(transactionResponse)
                                })
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.visible, edges: .all)
                            })
                            .onDelete(perform: { indexSet in
                                // Retrieve the item at the specified index from the transactionList
                                if let firstIndex = indexSet.first, firstIndex < groupedTransactions[dateKey]!.count {
                                    
                                    let transactionToDelete = groupedTransactions[dateKey]![firstIndex]
                                    Logger.logMessage(message: "TransactionList -> \(transactionToDelete)", logType: .debug)
                                    if let deleteClosure = onTransactionListSwipedToDelete {
                                        deleteClosure(transactionToDelete.transactionId)
                                    } else {
                                        Logger.logMessage(message: "TransactionList -> No delete closure provided", logType: .error)
                                    }
                                    
                                } else {
                                    Logger.logMessage(message: "TransactionList -> Index out of bounds or invalid", logType: .error)
                                }
                                
                            })
                            .background(.surfaceBackground)
                            
                            
                            
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
        .background(.surfaceBackground)
        
    }
}




#Preview {
    TransactionList(
        transactionList: DeveloperPreview.instance.transactions,
        onTransactionListItemClicked: { transactionResponse in
            
        },
        onTransactionListSwipedToDelete: { transactionId in
        }
        
    )
}
