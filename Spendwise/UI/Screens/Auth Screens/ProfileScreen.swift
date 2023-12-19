//
//  ProfileScreen.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 12/3/23.
//

import SwiftUI


struct ProfileScreen: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    @StateObject var profileViewModel: ProfileViewModel = ProfileViewModel()
    
    init() {
        // Large Navigation Title
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        // Inline Navigation Title
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    
    var body: some View {
        
        if let user = profileViewModel.user {
            NavigationStack {
                ZStack {
                    //Avatar
                    VStack {
                        
                        Spacer()
                        
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.blue)
                            .frame(width: 125, height: 125)
                            .padding()
                        
                        //Info: email, member since
                        VStack(alignment: .leading) {
                            
                            HStack{
                                Text("Email: ")
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.detailsText)
                                
                                Text(user.email)
                                    .foregroundStyle(.detailsText)
                                
                            }
                            
                            HStack{
                                Text("Member Since: ")
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.detailsText)
                                
                                Text("\(Date(timeIntervalSince1970: user.joinedAt).formatted(date: .abbreviated, time: .shortened))")
                                    .foregroundStyle(.detailsText)
                            }
                        }
                        
                        //sign out button
                        Button(action: {
                            mainViewModel.logout()
                        }, label: {
                            Text("Logout")
                                .tint(.red)
                        })
                        
                        Spacer()
                    }
                    .background(.surfaceBackground)
                }
                .navigationTitle(Text("Profile"))
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand to cover entire screen
                .background(.surfaceBackground)
            }
        } else {
            Text("Loading Profile...")
                .foregroundStyle(.headingText)
                .font(.system(size: 12))
        }
    }
}

#Preview {
    ProfileScreen()
}
