//
//  AddTransactionScreen.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/9/23.
//

import SwiftUI

struct AddTransactionScreen: View {
    
    @StateObject var addTransactionViewModel: AddTransactionViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusField: AnyKeyPath?
    
    init(addTransactionViewModel: AddTransactionViewModel) {
        
        self._addTransactionViewModel = StateObject(wrappedValue: addTransactionViewModel)
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .FAB
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().backgroundColor = .componentsBackground
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Form {
                        
                        Picker("Type of Transaction", selection: $addTransactionViewModel.transactionType) {
                            ForEach(TransactionType.allCases) { transactionType in
                                Text(transactionType.rawValue.capitalized)
                            }
                        }
                        .listRowSeparator(.hidden, edges: .all)
                        .listRowBackground(Colors.ComponentsBackgroundColor)
                        .pickerStyle(.segmented)
                        .padding()
                        
                        
                        VStack(alignment: .leading) {
                            Text("Amount")
                                .font(.system(size: 12))
                                .foregroundStyle(Colors.AmountTitleTextColor)
                            
                            
                            HStack {
                                Text(Locale.current.currencySymbol ?? "$")
                                    .font(.system(size: 35))
                                    .fontWeight(.bold)
                                
                                
                                TextField("0.00", text: $addTransactionViewModel.transactionAmount)
                                    .minimumScaleFactor(0.1)
                                    .font(.system(size: 35))
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                    .keyboardType(.decimalPad)
                                    .foregroundStyle(.detailsText)
                                    .onAppear {
                                        UITextField.appearance().clearButtonMode = .whileEditing
                                    }
                                    .focused($focusField, equals: \AddTransactionViewModel.transactionAmount)
                                .numbersOnly(text: $addTransactionViewModel.transactionAmount, includesDecimal: true)
                            }
                        }.listRowBackground(Colors.ComponentsBackgroundColor)
                        
                        HStack {
                            Text("Name")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            TextField("Enter title for transaction", text: $addTransactionViewModel.transactionTitle)
                                .autocorrectionDisabled(true)
                                .lineLimit(1)
                                .foregroundStyle(.detailsText)
                                .onAppear {
                                    UITextField.appearance().clearButtonMode = .whileEditing
                                }
                            .focused($focusField, equals: \AddTransactionViewModel.transactionTitle)
                            .background(.componentsBackground)
                        }
                        .listRowBackground(Colors.ComponentsBackgroundColor)
                     
//                        MARK: Simple Amount
//                        HStack {
//                            Text("Amount")
//                                .font(.system(size: 15))
//                                .fontWeight(.semibold)
//                            Text(Locale.current.currencySymbol ?? "$")
//                                .font(.system(size: 19))
//                                .fontWeight(.bold)
//
//                            TextField("Amount", text: $addTransactionViewModel.transactionAmount)
//                                .lineLimit(1)
//                                .keyboardType(.decimalPad)
//                                .foregroundStyle(.detailsText)
//                                .onAppear {
//                                    UITextField.appearance().clearButtonMode = .whileEditing
//                                }
//                                .focused($focusField, equals: \AddTransactionViewModel.transactionAmount)
//                            .numbersOnly(text: $addTransactionViewModel.transactionAmount, includesDecimal: true)
//                        }.listRowBackground(Colors.ComponentsBackgroundColor)
                        
                        HStack {
                            
                            Text("Note")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            TextField("Add notes to this transaction", text: $addTransactionViewModel.transactionNote)
                                .lineLimit(1)
                                .foregroundStyle(.detailsText)
                                .listRowBackground(Colors.ComponentsBackgroundColor)
                                .onAppear {
                                    UITextField.appearance().clearButtonMode = .whileEditing
                                }
                            .focused($focusField, equals: \AddTransactionViewModel.transactionNote)
                            
                        }.listRowBackground(Colors.ComponentsBackgroundColor)
                        
                        
                        Picker(selection: $addTransactionViewModel.transactionCategory) {
                            ForEach(TransactionCategory.allCases) { transactionCategory in
                                Text(transactionCategory.rawValue.capitalized)
                                    .font(.system(size: 15))
                                
                            }
                            
                        } label: {
                            Text("Category")
                                .foregroundStyle(.detailsText)
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                        }
                        .tint(.detailsText)
                        .listRowBackground(Colors.ComponentsBackgroundColor)
                        
                        
                        DatePicker(selection: $addTransactionViewModel.transactionDate, displayedComponents: .date) {
                            Text("Date")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                        }
                        .tint(.FAB)
                        .preferredColorScheme(.dark)
                        .listRowBackground(Colors.ComponentsBackgroundColor)

                        
//                        MARK: Fancy Note
//                        HStack {
//                            ZStack(alignment: .leading) {
//                                Image(systemName: "pencil")
//                                    .foregroundColor(Colors.NotePencilColor)
//                            }
//                            .frame(width: 35, height: 35)
//                            .background(Colors.NotePencilColor.opacity(0.1))
//                            .clipShape(.rect(cornerRadius: 10))
//                            
//                            VStack(alignment: .leading) {
//                                Text("Add Notes")
//                                    .foregroundStyle(Colors.NotePencilColor)
//                                    .font(.system(size: 16))
//                                    .fontWeight(.semibold)
//                                Text("Add some notes to this transaction")
//                                    .font(.system(size: 14))
//                            }
//                        }.listRowBackground(Colors.ComponentsBackgroundColor)
//                        
                        
                        
//                        MARK: Fancy Big Amount
//                        VStack(alignment: .leading) {
//                            Text("Amount")
//                                .font(.system(size: 12))
//                                .foregroundStyle(Colors.AmountTitleTextColor)
//                            
//                            
//                            HStack {
//                                Text(Locale.current.currencySymbol ?? "$")
//                                    .font(.system(size: 60))
//                                    .fontWeight(.bold)
//                                
//                                
//                                TextField("0.00", text: $addTransactionViewModel.transactionAmount)
//                                    .font(.system(size: 60))
//                                    .fontWeight(.bold)
//                                    .lineLimit(1)
//                                    .keyboardType(.decimalPad)
//                                    .foregroundStyle(.detailsText)
//                                    .onAppear {
//                                        UITextField.appearance().clearButtonMode = .whileEditing
//                                    }
//                                    .focused($focusField, equals: \AddTransactionViewModel.transactionAmount)
//                                .numbersOnly(text: $addTransactionViewModel.transactionAmount, includesDecimal: true)
//                            }
//                        }.listRowBackground(Colors.ComponentsBackgroundColor)
                    }
                    .onSubmit {
                        switch focusField {
                            case \AddTransactionViewModel.transactionAmount:
                                focusField = \AddTransactionViewModel.transactionTitle
                                
                            case \AddTransactionViewModel.transactionTitle:
                                focusField = \AddTransactionViewModel.transactionNote
                            
                            default:
                                break
                        }
                    }
                    .navigationTitle(Text(addTransactionViewModel.isUpdating ? "Edit Transaction" : "New Transaction"))
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                            }.buttonStyle(GrowingButton())
                                .foregroundStyle(.FAB)
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Save") {
                                addTransactionViewModel.isUpdating ? addTransactionViewModel.updateTransaction() : addTransactionViewModel.saveTransaction()
                                
                                dismiss()
                            }
                            .buttonStyle(GrowingButton())
                            .foregroundStyle(.FAB)
                            .disabled(!addTransactionViewModel.isComplete)
                            .opacity(addTransactionViewModel.isComplete ? 1.0 : 0.5)
                        }
                        
                        ToolbarItem(placement: .keyboard) {
                            HStack {
                                Spacer()
                                Button {
                                    focusField = nil
                                } label: {
                                    Image(systemName: "keyboard.chevron.compact.down")
                                }
                                
                            }
                        }
                    }
                    .background(.surfaceBackground)
                    .scrollContentBackground(.hidden)
                }
                .background(.surfaceBackground)
            }
        }
    }
}


struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}


#Preview {
    AddTransactionScreen(addTransactionViewModel: AddTransactionViewModel())
}
