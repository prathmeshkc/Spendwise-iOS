//
//  TrailingIconLabelStyle.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 10/29/23.
//

import SwiftUI

struct TrailingIconLabelStyle: LabelStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon.padding(EdgeInsets(top: 0, leading: -5, bottom: 0, trailing: 0))
        }
    }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
    static var trailingIcon: Self { Self() }
}
