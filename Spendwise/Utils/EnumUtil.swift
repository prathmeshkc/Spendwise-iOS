//
//  EnumUtil.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 12/19/23.
//

import Foundation

enum ChartType: CaseIterable, Identifiable {
    var id: Self { self }
    case Donut, Bar
}
