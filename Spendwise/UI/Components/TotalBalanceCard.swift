//
//  TotalBalanceCard.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 10/28/23.
//

import SwiftUI

//MARK: Old Balance Card
//struct TotalBalanceCard: View {
//    
//    let amountText: Double
//    let currentTimeFrameText: String
//    let onTransactionFilterClicked: (String) -> Void
//    
//    var body: some View {
//        
//        let amount = if amountText < 0 {
//            "- " + Helper.formatAmountWithLocale(amount: amountText * -1)
//        } else {
//            Helper.formatAmountWithLocale(amount: amountText)
//        }
//        
//        return VStack(alignment: .leading) {
//            HStack {
//                ZStack{
//                    Image(systemName: "banknote")
//                        .foregroundColor(Color.white)
//                }
//                .frame(width: 40, height: 40)
//                .background(.blue)
//                .cornerRadius(50)
//                .padding(.trailing, 8)
//                VStack(alignment: .leading) {
//                    Text("Balance")
//                        .font(.headline)
//                        .fontWeight(.bold)
//                        .foregroundColor(.blue)
//                    Text(amount)
//                        .font(.headline)
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                }
//                Spacer()
//                
//                //                Image(systemName: "chevron.right")
//                //                    .foregroundColor(.blue)
//                
//            }
//            .padding(.horizontal, 16)
//            .padding(.vertical, 20)
//            .frame(width: 380, alignment: .leading)
//            // Transaction filter
//            //            HStack(alignment: .center) {
//            //
//            //                Button(action: {
//            //
//            //                }, label: {
//            //                    Text(currentTimeFrameText)
//            //                        .foregroundStyle(.FAB)
//            //                        .font(.system(size: 16))
//            //                        .fontWeight(.medium)
//            //                        .padding(8)
//            ////                        .background(.monthlyFilterBackground)
//            ////                        .clipShape(.rect(cornerRadius: 10))
//            //
//            //                })
//            //                .padding([.top, .leading], 12)
//            //            }
//            //            .frame(maxWidth: .infinity, alignment: .leading)
//            //            VStack {
//            //                Text("BALANCE")
//            //                    .fontWeight(.semibold)
//            //                    .font(.system(size: 15))
//            //                    .foregroundStyle(.headingText)
//            //
//            //                Text(amount)
//            //                    .fontWeight(.semibold)
//            //                    .font(.system(size: 25))
//            //                    .foregroundStyle(.totalBalance)
//            //            }.frame(maxWidth: .infinity)
//            //        }
//            //        .frame(height: 130, alignment: .top)
//            //        .background(Colors.ComponentsBackgroundColor)
//            //        .clipShape(.rect(cornerRadius: 5))
//            //        .shadow(radius: 5)
//        }
//        .background(.blue.opacity(0.2))
//        .clipShape(.rect(cornerRadius: 10))
//        
//    }
//    
//    
//    
//}


struct TotalBalanceCard: View {
    var income: Double
    var expense: Double
    
    var body: some View {
        
        let balance = income - expense
        let balanceAmount = if balance < 0 {
            "- " + Helper.formatAmountWithLocale(amount: balance * -1)
        } else {
            Helper.formatAmountWithLocale(amount: balance)
        }

        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Text(balanceAmount)
                    .font(.title.bold())
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Image(systemName: expense > income ? "chart.line.downtrend.xyaxis" : "chart.line.uptrend.xyaxis")
                    .font(.title3)
                    .foregroundStyle(expense > income ? .red : .green)
            }.padding(.bottom, 25)
            
            HStack(spacing: 0) {
                ForEach(TransactionType.allCases, id: \.rawValue) { type in
                    let symbolImage = type == .INCOME ? "arrow.down" : "arrow.up"
                    let tint = type == .INCOME ? Colors.GreenIncomeColor : Colors.RedExpenseColor
                    
                    HStack(spacing: 10) {
                        Image(systemName: symbolImage)
                            .font(.callout.bold())
                            .foregroundStyle(tint)
                            .frame(width: 35, height: 35)
                            .background {
                                Circle().fill(tint.opacity(0.25).gradient)
                            }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(type.rawValue)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(tint)
                            
                            Text("\(Helper.formatAmountWithLocale(amount: type == .INCOME ? income : expense))")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        
                        if type == .INCOME {
                            Spacer(minLength: 10)
                        }
                    }
                }
            }
        }
        .padding([.horizontal, .bottom], 20)
        .padding(.top, 15)
        .background(.blue.opacity(0.2))
        .clipShape(.rect(cornerRadius: 10))
        
    }
}

#Preview {
    VStack {
//        TotalBalanceCard(amountText: 1807.123456, currentTimeFrameText: TransactionFilters.Monthly.rawValue
//        ) { filter in
//            
//        }.padding(.horizontal, 12)
        
        TotalBalanceCard(income: 6500, expense: 3200)
    }
}
