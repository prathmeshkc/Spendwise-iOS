//
//  ShimmerEffect.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 12/3/23.
//

import SwiftUI

struct ShimmerConfig {
    var tint: Color
    var highlight: Color
    var blur: CGFloat = 0
    var highlightOpacity: CGFloat = 1
    var speed: CGFloat = 2
}

fileprivate struct ShimmerEffectHelper: ViewModifier {
    //Shimmer Config
    var config: ShimmerConfig
    
    //Animation Properties
    @State private var moveTo: CGFloat = -0.7
    
    
    func body(content: Content) -> some View {
        content
        //        Adding Shimmer Animation with the help of Masking
        //        Hiding the Normal One and Adding Shimmer one instead
        
            .hidden()
            .overlay {
                //Changing the tint color
                Rectangle()
                    .fill(config.tint)
                    .mask {
                        content
                    }
                    .overlay {
                        //Shimmer
                        GeometryReader {
                            
                            let size = $0.size
                            let extraOffset = size.height / 2.5
                            
                            Rectangle()
                                .fill(config.highlight)
                                .mask {
                                    Rectangle()
                                    //Gradient for glowing at the center
                                        .fill(
                                            .linearGradient(colors: [.white.opacity(0),
                                                                     config.highlight.opacity(config.highlightOpacity), .white.opacity(0)], startPoint: .top, endPoint: .bottom)
                                        )
                                    //Adding Blur
                                        .blur(radius: config.blur)
                                    //Rotating Degree
                                        .rotationEffect(.init(degrees: -70))
                                    //Moving to the start
                                        .offset(x: moveTo > 0 ? extraOffset : -extraOffset)
                                        .offset(x: size.width * moveTo)
                                }
                        }
                        //Mask with the content
                        .mask {
                            content
                        }
                    }
                //Animating Movement
                    .onAppear {
                        DispatchQueue.main.async {
                            moveTo = -0.7
                        }
                    }
                    .animation(.linear(duration: config.speed).repeatForever(autoreverses: false), value: moveTo)
            }
    }
    
}



extension View {
    
    @ViewBuilder
    func shimmer(config: ShimmerConfig) -> some View {
        self
            .modifier(ShimmerEffectHelper(config: config))
    }
    
}

#Preview {
//    TransactionListItem(transactionResponse: TransactionResponse(transactionId: "1", userId: "user1", title: "Budget ", amount: 150.0, transactionType: "INCOME", category: "Savings & Debts", transactionDate: "Nov 01, 2023", note: "Budget for November 2023")) {
//        
//    }
    ShimmerTransactionListItem()
}
