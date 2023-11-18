//
//  TotalBalanceCard.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 10/28/23.
//

import SwiftUI

struct TotalBalanceCard: View {
    
    let amountText: Double
    let currentTimeFrameText: String
    let onTransactionFilterClicked: (String) -> Void
    
    var body: some View {
        
        let amount = if amountText < 0 {
            "- " + Helper.formatAmountWithLocale(amount: amountText * -1)
        } else {
            Helper.formatAmountWithLocale(amount: amountText)
        }
        
        return VStack(alignment: .leading) {
            HStack(alignment: .center) {
                
                Button(action: {
                    
                }, label: {
                    Text(currentTimeFrameText)
                        .foregroundStyle(.FAB)
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .padding(8)
//                        .background(.monthlyFilterBackground)
//                        .clipShape(.rect(cornerRadius: 10))
                        
                        
                    
                })
                .padding([.top, .leading], 12)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            VStack {
                Text("BALANCE")
                    .fontWeight(.semibold)
                    .font(.system(size: 15))
                    .foregroundStyle(.headingText)
                
                Text(amount)
                    .fontWeight(.semibold)
                    .font(.system(size: 25))
                    .foregroundStyle(.totalBalance)
            }.frame(maxWidth: .infinity)
        }
        .frame(height: 130, alignment: .top)
        .background(Colors.ComponentsBackgroundColor)
        .clipShape(.rect(cornerRadius: 5))
        .shadow(radius: 5)
        
    }
}

#Preview {
    TotalBalanceCard(amountText: -1807.123456, currentTimeFrameText: TransactionFilters.Monthly.rawValue
    ) { filter in
        
    }.padding(.horizontal, 12)
}
