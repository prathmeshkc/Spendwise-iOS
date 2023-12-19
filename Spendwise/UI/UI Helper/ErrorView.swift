//
//  ErrorView.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 12/12/23.
//

import SwiftUI

typealias EmptyStateActionHandler = () -> Void

struct ErrorView: View {
    
    private let handler: EmptyStateActionHandler
    private var error: Error
    
    internal init(
        error: Error,
        handler: @escaping EmptyStateActionHandler) {
            self.error = error
            self.handler = handler
        }
    
    
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.icloud.fill")
                .foregroundColor(.gray)
                .font(.system(size: 50, weight: .heavy))
            Text("Ooops...")
                .font(.system(size: 30, weight: .heavy))
                .foregroundStyle(.detailsText)
            Text(error.localizedDescription)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            Button("Retry") {
                handler()
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 10)
            .font(.system(size: 20, weight: .bold))
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

#Preview {
    ErrorView(error: APIError.decodingError) {}
}
