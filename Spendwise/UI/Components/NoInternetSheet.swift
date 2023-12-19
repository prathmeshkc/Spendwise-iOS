//
//  NoInternetSheet.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 12/16/23.
//

import SwiftUI

struct NoInternetSheet: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                LottieView(animation: .noInternet, loopMode: .loop)
                    .frame(width: 400, height: 400)
                
                Text("No Internet Connection")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.detailsText)
                    .padding(.top, 8)

                Spacer()
            }
            .background(.componentsBackground)
            
        }
    }
}

#Preview {
    NoInternetSheet()
}
