//
//  RegisterScreen.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/23/23.
//

import SwiftUI

struct RegisterScreen: View {
    
    @StateObject var registerViewModel: RegisterViewModel = RegisterViewModel()
    @EnvironmentObject var authViewModel: MainViewModel
    @FocusState private var focusField: AnyKeyPath?
    
    var body: some View {
        NavigationStack {
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
                                    
                                    TextField(text: $registerViewModel.email, label: {
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
                                    .focused($focusField, equals: \RegisterViewModel.email)
                                    .onSubmit {
                                        focusField = \RegisterViewModel.password
                                    }
                                }
                                
                                Text(registerViewModel.emailPrompt)
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
                                    
                                    SecureField("Atleast 5 characters", text: $registerViewModel.password)
                                        .textContentType(.newPassword)
                                        .autocorrectionDisabled()
                                        .lineLimit(1)
                                        .foregroundStyle(.detailsText)
                                        .listRowBackground(Colors.ComponentsBackgroundColor)
                                        .focused($focusField, equals: \RegisterViewModel.password)
                                        .onSubmit {
                                            focusField = \RegisterViewModel.confirmPassword
                                        }
                                }
                                Text(registerViewModel.passwordPrompt)
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.headingText)
                            }
                            .listRowBackground(Colors.ComponentsBackgroundColor)
                            .padding(12)
                            
                            VStack {
                                HStack {
                                    
                                    Text("Confirm Password")
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.detailsText)
                                    
                                    Spacer(minLength: 18)
                                    
                                    SecureField("Password@123", text: $registerViewModel.confirmPassword)
                                        .textContentType(.newPassword)
                                        .autocorrectionDisabled()
                                        .lineLimit(1)
                                        .foregroundStyle(.detailsText)
                                        .listRowBackground(Colors.ComponentsBackgroundColor)
                                        .focused($focusField, equals: \RegisterViewModel.confirmPassword)
                                }
                                Text(registerViewModel.confirmPwPrompt)
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
                                try await authViewModel.registerUserWithEmailPassword(email: registerViewModel.email, password: registerViewModel.password)
                            }
                            
                        }) {
                            Text("Register")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 250, height: 50)
                                .background(.FAB)
                                .cornerRadius(10)
                        }
                        .disabled(!registerViewModel.canSubmit)
                        .opacity(registerViewModel.canSubmit ? 1.0 : 0.5)
                        
                        Spacer(minLength: 24)
                        
                        NavigationLink {
                            LoginScreen()
                                .navigationBarBackButtonHidden()
                        } label: {
                            HStack(spacing: 3) {
                                Text("Already have an account?")
                                Text("Login")
                                    .fontWeight(.bold)
                            }.font(.system(size: 14))
                        }
                        
                        
                    }
                    .background(.surfaceBackground)
                    .scrollContentBackground(.hidden)
                    
                }
                .scrollIndicators(.hidden)
            }
            .background(.surfaceBackground)
        }
    }
}

#Preview {
    RegisterScreen()
}
