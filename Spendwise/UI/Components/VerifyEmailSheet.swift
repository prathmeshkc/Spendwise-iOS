//
//  VerifyEmailSheet.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 12/15/23.
//

import SwiftUI

struct VerifyEmailSheet: View {
    var body: some View {
        
        NavigationStack {
            VStack {
                LottieView(animation: .verifyEmail, loopMode: .loop)
                    .frame(width: 400, height: 400)
                
                Text("Verify your account")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.detailsText)
                
                Text("Account activation link has been sent to the email address you provided")
                    .font(.system(size: 16))
                    .foregroundStyle(.detailsText)

                Spacer()
            }
            .background(.componentsBackground)
            
        }
    }
}

#Preview {
    VerifyEmailSheet()
}
