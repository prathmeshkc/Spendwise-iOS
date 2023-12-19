//
//  DateFilterView.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 12/14/23.
//

import SwiftUI

struct DateFilterView: View {
    
    @Binding var start: Date
    @Binding var end: Date
    
    var onSubmit: (Date, Date) -> ()
    var onClose: () -> ()
    
    var body: some View {
        VStack(spacing: 15) {
            DatePicker(selection: $start, displayedComponents: .date) {
                Text("Start Date")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
            }
            .tint(.FAB)
            .preferredColorScheme(.dark)
            
            DatePicker(selection: $end, displayedComponents: .date) {
                Text("End Date")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
            }
            .tint(.FAB)
            .preferredColorScheme(.dark)
            
            HStack(spacing: 15) {
                
                Button {
                    onClose()
                } label: {
                    Text("Cancel")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
                .tint(.red)
                
                
                Button {
                    onSubmit(start, end)
                } label: {
                    Text("Filter")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
                .tint(.FAB)
            }
            .padding(.top, 10)
        }
        .padding(15)
        .background(.bar, in: .rect(cornerRadius: 10))
        .padding(.horizontal, 30)
    }
}
