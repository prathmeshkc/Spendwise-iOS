//
//  TransactionListItem.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 10/29/23.
//

import SwiftUI

struct TransactionListItem: View {
    
    let transactionResponse: TransactionResponse
    let onTransactionListItemClicked: () -> Void
    
    var body: some View {
        
        let transactionImage = switch transactionResponse.category {
        case "Entertainment": {
            "tv.and.mediabox"
        }
            
        case "Food": {
            "fork.knife"
        }
            
        case "Healthcare": {
            "medical.thermometer"
        }
            
        case "Housing": {
            "house"
        }
            
        case "Insurance": {
            "Insurance"
        }
            
        case "Miscellaneous": {
            "infinity"
        }
            
        case "Personal Spending": {
            "person"
        }
            
        case "Savings & Debts": {
            "banknote"
        }
            
        case "Transportation": {
            "bus.fill"
        }
            
        case "Utilities": {
            "screwdriver"
        }
            
        default: {
            "infinity"
        }
        }
        
        let transactionTitleText = (transactionResponse.title.count > 18) ? transactionResponse.title.prefix(18) + "..." : transactionResponse.title
        
        let transactionAmount: String
        let transactionAmountColor: Color
        switch transactionResponse.transactionType {
            case TransactionType.EXPENSE.rawValue:
                transactionAmount = "-" + Helper.formatAmountWithLocale(amount: transactionResponse.amount)
                transactionAmountColor = .redExpense
            case TransactionType.INCOME.rawValue:
                transactionAmount = "+" + Helper.formatAmountWithLocale(amount: transactionResponse.amount)
                transactionAmountColor = .greenIncome
            default:
                transactionAmount = Helper.formatAmountWithLocale(amount: transactionResponse.amount)
                transactionAmountColor = .detailsText
        }
        
        
        
        return VStack {
            HStack(alignment: .center) {
                
                ZStack(alignment: .leading) {
                    Image(systemName: transactionImage())
                        .foregroundColor(.white)
                }
                .frame(width: 48, height: 48, alignment: .center)
                .background(.surfaceBackground)
                .padding(.leading, 13)
                
                Spacer(minLength: 12)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(transactionTitleText)
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .foregroundColor(.detailsText)
                        
                        Text(transactionResponse.category)
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                            .foregroundStyle(.detailsText)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(transactionAmount)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(transactionAmountColor)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Text(transactionResponse.transactionDate)
                        .font(.system(size: 12))
                        .fontWeight(.semibold)
                        .foregroundStyle(.detailsText)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                }
                .frame(maxHeight: .infinity)
                .padding(.trailing, 17)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .background(.componentsBackground)
        .frame(height: 68)
        .padding(.vertical, 7)
        .padding(.horizontal, 16)
        .clipShape(.rect(cornerRadius: 5))
        .shadow(radius: 5)
        .onTapGesture {
            //TODO:On Transaction Item Clicked
            onTransactionListItemClicked()
        }
    }
}

#Preview {
    TransactionListItem(
        transactionResponse: TransactionResponse(
            transactionId: "",
            userId: "",
            title: "Onions",
            amount: 1234.0,
            transactionType: "INCOME",
            category: "Utilities",
            transactionDate: "Oct 30, 2023",
            note: ""
        ),
        onTransactionListItemClicked: {
        })
}
