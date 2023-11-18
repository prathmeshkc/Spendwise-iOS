//
//  TotalIncomeExpenseCard.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 10/26/23.
//

import SwiftUI

struct TotalIncomeExpenseCard: View {
    
    let type: TransactionType
    let amountText: Double
    
    var body: some View {
        
        let titleText: String
        let transactionTypeIcon: String
        let amountColor: Color
        
        let amount = Helper.formatAmountWithLocale(amount: amountText)
        
        switch type {
                
            case .EXPENSE:
                titleText = "EXPENSE"
                transactionTypeIcon = "ExpenseIcon"
                amountColor = Colors.RedExpenseColor
                
            case .INCOME:
                titleText = "INCOME"
                transactionTypeIcon = "IncomeIcon"
                amountColor = Colors.GreenIncomeColor
        }
        
        return VStack {
            HStack {
                Text(titleText)
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundStyle(Colors.HeadingTextColor)
                    .padding(.leading, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Image(transactionTypeIcon)
            }
            .frame(maxWidth: .infinity)
            .padding(.trailing, 12)
            
            
            Text(amount)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .lineLimit(1)
                .truncationMode(.tail)
                .foregroundStyle(amountColor)
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 104)
        .background(Colors.ComponentsBackgroundColor)
        .clipShape(.rect(cornerRadius: 5))
        .shadow(radius: 5)
    }
}

#Preview {
    HStack {
        TotalIncomeExpenseCard(type: .INCOME, amountText: 3570.00)
        TotalIncomeExpenseCard(type: .EXPENSE, amountText: 1767.00)
    }.padding([.leading, .trailing, .top], 12)
        .padding(.bottom, 10)
}
