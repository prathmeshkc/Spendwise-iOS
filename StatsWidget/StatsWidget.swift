//
//  StatsWidget.swift
//  StatsWidget
//
//  Created by Prathmesh Chaudhari on 12/21/23.
//

import WidgetKit
import SwiftUI



struct StatsWidgetEntryView : View {
    var entry: WidgetEntry

    var body: some View {
        let stats = Helper.calculateSummary(transactions: DeveloperPreview.instance.transactions)
        TotalBalanceCard(income: stats.income, expense: stats.expense)
    }
}

struct StatsWidget: Widget {
    let kind: String = "StatsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StatsWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .configurationDisplayName("Spendwise Widget")
        .description("See the current month's Spendwise Stats")
        .supportedFamilies([.systemMedium])
    }
}



#Preview(as: .systemSmall) {
    StatsWidget()
} timeline: {
    WidgetEntry(date: .now, transactions: DeveloperPreview.instance.transactions)
}

//#Preview {
//    StatsWidgetEntryView(entry: WidgetEntry.mockWidgetEntry())
//        .previewContext(WidgetPreviewContext(family: .systemMedium))
//}
