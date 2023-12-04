//
//  AddTransactionForm2.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/23/23.
//

import Foundation
import SwiftUI

struct AddTransactionForm2: View {
    @State private var name = ""
    @State private var selectedDate = Date()
    @State private var note = ""
    @State private var selectedCategory = "Category 1"
    @State private var amount = ""
    @State private var isExpense = true
    @State private var isModalPresented = false
    
    var body: some View {
        NavigationView {
            
            VStack{
                HStack{
                    Text("Name")
                    Spacer()
                    TextField("Transaction name", text: $name)
                }
                Divider()
                
                HStack{
                    Text("Note")
                    Spacer()
                    TextField("Description", text: $note)
                }
                Divider()
                
                Toggle(isOn: $isExpense) {
                    Text("Expense")
                }
                Divider()
                HStack{
                    Text("Category")
                    Spacer()
                    Picker("Category", selection: $selectedCategory) {
                                            Text("Category 1").tag("Category 1")
                                            Text("Category 2").tag("Category 2")
                                            Text("Category 3").tag("Category 3")
                                        }
                }
                
                
                Divider()
                DatePicker("Date & Time", selection: $selectedDate, displayedComponents: [.date])
                Divider()
                HStack{
                    Text("$").font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                Spacer()
                Button(action: {
                    // Action to save data
                    isModalPresented.toggle()
                }) {
                    Text("Save")
                
                
                        
                }
                
                
                
                
                
                
            }
            .navigationBarTitle("New Transaction")
            .padding(.all, 20)
            
            
        }
    }
}

#Preview {
    AddTransactionForm2()
}
