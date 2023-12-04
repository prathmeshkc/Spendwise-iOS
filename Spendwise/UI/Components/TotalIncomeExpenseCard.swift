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
                titleText = "Expense"
                transactionTypeIcon = "arrow.down"
                amountColor = Colors.RedExpenseColor
                
            case .INCOME:
                titleText = "Income"
                transactionTypeIcon = "arrow.up"
                amountColor = Colors.GreenIncomeColor
        }
        
        return VStack {
            HStack {
                ZStack{
                    Image(systemName: transactionTypeIcon)
                        .foregroundColor(Color.white)
                }
                .frame(width: 40, height: 40)
                .background(amountColor)
                .cornerRadius(50)
                .padding(.trailing, 8)
                VStack(alignment: .leading) {
                    Text(titleText)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(amountColor)
                    Text(amount)
                        .font(.headline)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                }
                Spacer()
                
                
            }
            .padding(.all, 15)
            
            
        }
        .frame(height: 90)
        .background(amountColor.opacity(0.2))
        .clipShape(.rect(cornerRadius: 10))
        .padding(.horizontal, 3)
        
    }
}

#Preview {
    HStack {
        TotalIncomeExpenseCard(type: .INCOME, amountText: 3570.00)
        TotalIncomeExpenseCard(type: .EXPENSE, amountText: 1767.00)
    }.padding([.leading, .trailing, .top], 12)
        .padding(.bottom, 10)
}
