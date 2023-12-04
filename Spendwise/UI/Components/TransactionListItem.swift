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
        
        let transactionImageColor = switch transactionResponse.category {
        case "Entertainment": {
            Color.red
        }
            
        case "Food": {
            Color.yellow
        }
            
        case "Healthcare": {
            Color.blue
        }
            
        case "Housing": {
            Color.green
        }
            
        case "Insurance": {
            Color.gray
        }
            
        case "Miscellaneous": {
            Color.orange
        }
            
        case "Personal Spending": {
            Color.cyan
        }
            
        case "Savings & Debts": {
            Color.pink
        }
            
        case "Transportation": {
            Color.mint
        }
            
        case "Utilities": {
            Color.teal
        }
            
        default: {
            Color.purple
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
                Spacer(minLength: 12)
                ZStack{
                    Image(systemName: transactionImage())
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    
                }
                .frame(width: 36, height: 36)
                .background(transactionImageColor())
                .cornerRadius(5)
                .padding([.horizontal], 12)
                
                
                
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(transactionTitleText)
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .foregroundColor(.detailsText)
                            .padding(.bottom, 0.1)
                        
                        Text(transactionResponse.category)
                            .font(.system(size: 12))
                            .foregroundStyle(.detailsText)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .foregroundColor(Color.gray)
                        
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(transactionAmount)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(transactionAmountColor)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                .padding(.trailing, 17)
                
//                VStack{
//                    HStack{
////                        HStack {
////                            VStack(alignment: .leading) {
////                                Text(transactionTitleText)
////                                    .font(.system(size: 16))
////                                    .fontWeight(.bold)
////                                    .lineLimit(1)
////                                    .truncationMode(.tail)
////                                    .foregroundColor(.detailsText)
////                                    .padding(.bottom, 0.1)
////                                
////                                Text(transactionResponse.category)
////                                    .font(.system(size: 12))
////                                    .foregroundStyle(.detailsText)
////                                    .lineLimit(1)
////                                    .truncationMode(.tail)
////                                    .foregroundColor(Color.gray)
////                                
////                                
////                            }
////                            
////                            Spacer()
////                        }
////                        .frame(maxWidth: .infinity, maxHeight: .infinity)
////                        
////                        Spacer()
////                        
////                        VStack(alignment: .trailing) {
////                            Text(transactionAmount)
////                                .font(.system(size: 16))
////                                .fontWeight(.semibold)
////                                .foregroundStyle(transactionAmountColor)
////                                .lineLimit(1)
////                                .truncationMode(.tail)
////                        }
//                        
//                    }
//                    .frame(maxHeight: .infinity)
//                    .padding(.trailing, 17)
//                    
//                    Spacer(minLength: 0.1)
//                    
////                    HStack{
////                        Divider()
////                            .frame(width: 310, height: 0.7)
////                            .background(Color.gray)
////                        Spacer()
////                    }
//                    
//                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .background(.surfaceBackground)
        .frame(height: 68)
        .onTapGesture {
            onTransactionListItemClicked()
        }
    }
}

struct ShimmerTransactionListItem: View {
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 36, height: 36)
                .padding([.leading, .trailing], 12)
            
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 16)
                    .padding(.bottom, 4)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 12)
            }
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 16)
                .padding(.trailing, 17)
        }
        .padding(.vertical, 16)
        .frame(height: 68)
        .shimmer(config: .init(tint: .gray.opacity(0.3), highlight: .white, blur: 5))
        .background(.surfaceBackground)
    }
}



#Preview {
    VStack {
        TransactionListItem(
            transactionResponse: TransactionResponse(
                transactionId: "",
                userId: "",
                title: "Onions",
                amount: 1234.0,
                transactionType: "Food",
                category: "Food",
                transactionDate: "Oct 30, 2023",
                note: ""
            ),
            onTransactionListItemClicked: {
            })
        
        ShimmerTransactionListItem()
    }
}
