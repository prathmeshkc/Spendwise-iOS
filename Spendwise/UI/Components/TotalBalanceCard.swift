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
            HStack {
                ZStack{
                    Image(systemName: "banknote")
                        .foregroundColor(Color.white)
                }
                .frame(width: 40, height: 40)
                .background(.blue)
                .cornerRadius(50)
                .padding(.trailing, 8)
                VStack(alignment: .leading) {
                    Text("Balance")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text(amount)
                        .font(.headline)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                }
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.blue)
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .frame(width: 380, alignment: .leading)
            
            //            HStack(alignment: .center) {
            //
            //                Button(action: {
            //
            //                }, label: {
            //                    Text(currentTimeFrameText)
            //                        .foregroundStyle(.FAB)
            //                        .font(.system(size: 16))
            //                        .fontWeight(.medium)
            //                        .padding(8)
            ////                        .background(.monthlyFilterBackground)
            ////                        .clipShape(.rect(cornerRadius: 10))
            //
            //                })
            //                .padding([.top, .leading], 12)
            //            }
            //            .frame(maxWidth: .infinity, alignment: .leading)
            //            VStack {
            //                Text("BALANCE")
            //                    .fontWeight(.semibold)
            //                    .font(.system(size: 15))
            //                    .foregroundStyle(.headingText)
            //
            //                Text(amount)
            //                    .fontWeight(.semibold)
            //                    .font(.system(size: 25))
            //                    .foregroundStyle(.totalBalance)
            //            }.frame(maxWidth: .infinity)
            //        }
            //        .frame(height: 130, alignment: .top)
            //        .background(Colors.ComponentsBackgroundColor)
            //        .clipShape(.rect(cornerRadius: 5))
            //        .shadow(radius: 5)
        }
        .background(.blue.opacity(0.2))
        .clipShape(.rect(cornerRadius: 10))
        
    }
        
}

#Preview {
    TotalBalanceCard(amountText: 1807.123456, currentTimeFrameText: TransactionFilters.Monthly.rawValue
    ) { filter in
        
    }.padding(.horizontal, 12)
}
