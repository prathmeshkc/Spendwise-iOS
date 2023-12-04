//
//  ProfileScreen.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 12/3/23.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    var body: some View {
        ZStack {
            Button(action: {
                mainViewModel.logout()
            }, label: {
                Text("Logout")
                    .foregroundStyle(.FAB)
            })
        }
        .background(.surfaceBackground)
    }
}

#Preview {
    ProfileScreen()
}
