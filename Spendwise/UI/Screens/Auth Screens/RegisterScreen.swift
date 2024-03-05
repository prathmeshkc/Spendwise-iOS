//
//  RegisterScreen.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/23/23.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

struct RegisterScreen: View {
    
    @StateObject var registerViewModel: RegisterViewModel = RegisterViewModel()
    @EnvironmentObject var authViewModel: MainViewModel
    @FocusState private var focusField: AnyKeyPath?
    
    @State private var isAlertPresented: Bool = false
    @State private var alertText: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        ZStack {
                            Image("RegisterScreenImage")
                                .resizable()
                                .frame(maxHeight: 360)
                            
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
                        
                        
                        Button(action: {
                            
                            Task {
                                do {
                                    try await authViewModel.registerUserWithEmailPassword(email: registerViewModel.email, password: registerViewModel.password)
                                } catch let error {
                                    isAlertPresented = true
                                    alertText = error.localizedDescription
                                }
                            }
                            
                        }) {
                            Text("Register")
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
                        .disabled(!registerViewModel.canSubmit)
                        .opacity(registerViewModel.canSubmit ? 1.0 : 0.5)
                        
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
            .navigationDestination(isPresented: $authViewModel.sendVerifyEventToLoginScreen, destination: {
                LoginScreen(isVerifyEmailSheetPresented: true)
                    .navigationBarBackButtonHidden()
            })
            .background(.surfaceBackground)
        }
    }
}

#Preview {
    //    RegisterScreen()
    VStack {
        HStack {
            Image("google")
                .resizable()
                .frame(width: 20, height: 20)
            Text("Sign In With Google")
            
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
        }
        .padding(15)
        .background(Color.white)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.gray, lineWidth: 2)
        )
    }
}
