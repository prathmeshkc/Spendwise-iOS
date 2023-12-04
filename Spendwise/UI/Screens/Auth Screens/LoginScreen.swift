//
//  LoginScreen.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/23/23.
//

import SwiftUI

struct LoginScreen: View {
    
    @StateObject var loginViewModel: LoginViewModel = LoginViewModel()
    @EnvironmentObject var authViewModel: MainViewModel
    @FocusState private var focusField: AnyKeyPath?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ZStack {
                        Image("RegisterScreenImage")
                            .resizable()
                            .frame(maxHeight: 330)
                        
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .surfaceBackground]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .blur(radius: 50)
                    }
                    Text("Elevate your experience")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Text("Achieve financial freedom with our feature rich expense tracker app, your friendly neighborhood budget tracker")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.gray)
                        .padding(.horizontal, 20)
                    
                    VStack {
                        VStack {
                            HStack {
                                Text("Email")
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.detailsText)
                                
                                Spacer(minLength: 50)
                                
                                TextField(text: $loginViewModel.email, label: {
                                    Text(verbatim: "example@domain.com")
                                })
                                .keyboardType(.emailAddress)
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                                    .lineLimit(1)
                                    .foregroundStyle(.detailsText)
                                    .onAppear {
                                        UITextField.appearance().clearButtonMode = .whileEditing
                                    }
                                    .focused($focusField, equals: \LoginViewModel.email)
                                    .onSubmit {
                                        focusField = \LoginViewModel.password
                                    }
                            }
                            Text(loginViewModel.emailPrompt)
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .foregroundStyle(.headingText)
                        }
                        .listRowBackground(Colors.ComponentsBackgroundColor)
                        .padding(12)
                        
                        
                        VStack {
                            HStack {
                                
                                Text("Password")
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.detailsText)
                                
                                Spacer(minLength: 18)
                                
                                SecureField("Atleast 5 characters", text: $loginViewModel.password)
                                    .textContentType(.newPassword)
                                    .autocorrectionDisabled()
                                    .lineLimit(1)
                                    .foregroundStyle(.detailsText)
                                    .listRowBackground(Colors.ComponentsBackgroundColor)
                                    .focused($focusField, equals: \LoginViewModel.password)
                            }
                            Text(loginViewModel.passwordPrompt)
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .foregroundStyle(.headingText)
                        }
                        .listRowBackground(Colors.ComponentsBackgroundColor)
                        .padding(12)

                    }
                    .padding(.horizontal, 12)
                    
                    Spacer(minLength: 12)
                    
                    Button(action: {
                        Task {
                            try await authViewModel.loginUserWithEmailPassword(email: loginViewModel.email, password: loginViewModel.password)
                        }
                        
                    }) {
                        Text("Login")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 250, height: 50)
                            .background(.FAB)
                            .cornerRadius(10)
                    }
                    .disabled(!loginViewModel.canSubmit)
                    .opacity(loginViewModel.canSubmit ? 1.0 : 0.5)
                    
                    Spacer(minLength: 24)
                    
                    Button(action: {
                        dismiss()
                    }, label: {
                        HStack(spacing: 3) {
                            Text("Don't have an account?")
                            Text("Register")
                                .fontWeight(.bold)
                        }.font(.system(size: 14))
                    })

                }
                .background(.surfaceBackground)
                .scrollContentBackground(.hidden)
                
            }
            .scrollIndicators(.hidden)
        }
        .background(.surfaceBackground)
    }
}

#Preview {
    LoginScreen()
}
