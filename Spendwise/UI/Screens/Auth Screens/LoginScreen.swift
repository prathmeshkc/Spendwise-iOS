//
//  LoginScreen.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/23/23.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

struct LoginScreen: View {
    
    @StateObject var loginViewModel: LoginViewModel = LoginViewModel()
    @EnvironmentObject var authViewModel: MainViewModel
    @FocusState private var focusField: AnyKeyPath?
    @Environment(\.dismiss) var dismiss
    
    @State private var isAlertPresented: Bool = false
    @State private var alertText: String = ""
    @State var isVerifyEmailSheetPresented: Bool = false
    
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
                    
                    VStack {
                        Text("Elevate your experience")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Text("Achieve financial freedom with our feature rich expense tracker app, your friendly neighborhood budget tracker")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.gray)
                            .padding(.horizontal, 20)
                    }
                    
                    
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
                    
                    
                    
                    Button(action: {
                        Task {
                            do {
                                try await authViewModel.loginUserWithEmailPassword(email: loginViewModel.email, password: loginViewModel.password)
                            } catch EmailNotVerifiedError.emailNotVerified {
                                isAlertPresented = true
                                alertText = "Please Verify Email!"
                                isVerifyEmailSheetPresented = true
                            } catch let error {
                                isAlertPresented = true
                                alertText = error.localizedDescription
                            }
                        }
                        
                    }) {
                        Text("Login")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 250, height: 50)
                            .background(.FAB)
                            .cornerRadius(10)
                    }
                    .alert(Text("\(alertText)"), isPresented: $isAlertPresented, actions: {
                        Button(role: .cancel) {} label: {
                            Text("Dismiss")
                        }
                    })
                    .disabled(!loginViewModel.canSubmit)
                    .opacity(loginViewModel.canSubmit ? 1.0 : 0.5)
                    
                    HStack {
                        VStack {
                            Divider()
                                .frame(height: 2)
                        }
                        
                        Text("OR")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.detailsText)
                            
                        VStack {
                            Divider()
                                .frame(height: 2)
                        }
                    }.padding(.horizontal, 50)
                    
                    
                    Button( action:{
                        //        get app client id
                        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                        
                        //Create Google Sign In configuration object
                        let config = GIDConfiguration(clientID: clientID)
                        GIDSignIn.sharedInstance.configuration = config
                        
                        let topVC = Application_utility.rootViewController
                        
                        
                        Task {
                            do {
                                let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
                                try await authViewModel.signInWithGoogle(gidSignInResult: gidSignInResult)
                            } catch let error {
                                isAlertPresented = true
                                alertText = error.localizedDescription
                            }
                        }
                    }) {
                        HStack {
                            Image("google")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Sign In With Google")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(15)
                        .background(Colors.SurfaceBackgroundColor)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                    }
                    .alert(Text("\(alertText)"), isPresented: $isAlertPresented, actions: {
                        Button(role: .cancel) {} label: {
                            Text("Dismiss")
                        }
                    })

                    
                    
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
            .sheet(isPresented: $isVerifyEmailSheetPresented, content: {
                VerifyEmailSheet()
                    .presentationDetents([.fraction(0.7)])
                    .presentationDragIndicator(.visible)
            })
            .scrollIndicators(.hidden)
        }
        .background(.surfaceBackground)
    }
}

#Preview {
    LoginScreen()
}
