//
//  NumbersOnlyViewModifier.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 11/19/23.
//

import SwiftUI
import Combine

struct NumbersOnlyViewModifier: ViewModifier {
    
    @Binding var text: String
    var includesDecimal: Bool
    
    func body(content: Content) -> some View {
        content
            .keyboardType(includesDecimal ? .decimalPad : .numberPad)
            .onReceive(Just(text), perform: { newValue in
                debugPrint("Amount - \(newValue)")
                var numbers = "0123456789"
                let decimalSeperator: String = Locale.current.decimalSeparator ?? "."
                
                if includesDecimal {
                    numbers += decimalSeperator
                }
                
                if newValue.components(separatedBy: decimalSeperator).count-1 > 1 {
                    let filtered = newValue
                    self.text = String(filtered.dropLast())
                } else {
                    let filtered = newValue.filter { numbers.contains($0)}
                    if filtered != newValue {
                        self.text = filtered
                    }
                }
                
            })
    }
}

extension View {
    func numbersOnly(text: Binding<String>, includesDecimal: Bool = false) -> some View {
        self.modifier(NumbersOnlyViewModifier(text: text, includesDecimal: includesDecimal))
    }
}
