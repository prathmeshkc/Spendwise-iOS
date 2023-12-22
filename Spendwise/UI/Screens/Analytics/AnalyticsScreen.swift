//
//  AnalyticsScreen.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 12/3/23.
//

import SwiftUI
import Charts

struct AnalyticsScreen: View {
    
    @StateObject var analyticsViewModel: AnalyticsViewModel = AnalyticsViewModel()
    
    
    @State var showFilterView: Bool = false
    
    @State private var selectedCount: Int?
    @State private var selectedExpenditureByCategory: ExpenditureByCategory?
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .FAB
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().backgroundColor = .componentsBackground
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    
                    HStack {
                        
                        if analyticsViewModel.chartType == .Donut {
                            Button(action: {
                                showFilterView = true
                            }, label: {
                                Text("\(Helper.dateToString(analyticsViewModel.startDate)) - \(Helper.dateToString(analyticsViewModel.endDate))")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.gray)
                            })
                        }
                        
                        Spacer()
                        
                        Picker("Type of Chart", selection: $analyticsViewModel.chartType) {
                            ForEach(ChartType.allCases) { chartType in
                                Image(systemName: chartType == .Donut ? "chart.pie.fill" : "chart.bar.fill").tint(.FAB)
                            }
                        }
                        .pickerStyle(.segmented)
                        .fixedSize()
                    }.padding(.horizontal, 12)
                    
                    switch analyticsViewModel.resultState {
                            
                        case .loading:
                            
                            Text("Loading...").foregroundStyle(.detailsText).fontWeight(.regular)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.surfaceBackground.ignoresSafeArea())
                                .transition(.move(edge: .bottom))
                            
                        case .failed(let error):
                            
                            ErrorView(error: error) {
                                self.analyticsViewModel.getAllTransaction(startDate: analyticsViewModel.startDate.toString, endDate: analyticsViewModel.endDate.toString)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand to cover entire screen
                            .background(Color.surfaceBackground.ignoresSafeArea())
                            .transition(.move(edge: .bottom))
                            
                        case .success(_):
                            
                            if analyticsViewModel.expenditurePercentageByCategory.isEmpty {
                                VStack {
                                    Spacer()
                                    LottieView(animation: .noTransactionFound, loopMode: .loop)
                                        .frame(width: 200, height: 200)
                                    Text("No Transactions Found")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.detailsText)
                                        .padding(.top, 8)
                                    Spacer()
                                }
                            } else {
                                if analyticsViewModel.chartType == .Donut {
                                    Chart(analyticsViewModel.expenditurePercentageByCategory) { expenditureByCategory in
                                        SectorMark(
                                            angle: .value("Percentage", expenditureByCategory.percentage),
                                            innerRadius: .ratio(0.65),
                                            outerRadius: selectedExpenditureByCategory?.category == expenditureByCategory.category ? 175 : 150,
                                            angularInset: 1
                                        )
                                        .foregroundStyle(expenditureByCategory.color)
                                        .cornerRadius(10)
                                    }
                                    .chartAngleSelection(value: $selectedCount)
                                    .chartBackground { _ in
                                        if let selectedExpenditureByCategory {
                                            VStack {
                                                Text(selectedExpenditureByCategory.category)
                                                    .foregroundStyle(.detailsText)
                                                    .fontWeight(.semibold)
                                                Text(Helper.formatDoubleWithTwoDecimals(value: selectedExpenditureByCategory.percentage) + "%")
                                                    .foregroundStyle(.detailsText)
                                                    .fontWeight(.semibold)
                                            }
                                        } else {
                                            if !analyticsViewModel.expenditurePercentageByCategory.isEmpty {
                                                Text("Select a segment")
                                                    .foregroundStyle(.detailsText)
                                            }
                                        }
                                    }
                                    .frame(height: 350)
                                    .padding()
                                } else {
                                    
                                }
                            }
                    }
                    
                    Spacer()
                }
                .blur(radius: showFilterView ? 8 : 0)
                .disabled(showFilterView)
                .onChange(of: selectedCount) { oldValue, newValue in
                    if let newValue {
                        withAnimation {
                            getSelectedExpenditureByCategory(value: newValue)
                        }
                    }
                }
            }
            .overlay {
                if showFilterView {
                    DateFilterView(start: $analyticsViewModel.startDate, end: $analyticsViewModel.endDate, onSubmit: { start, end in
                        analyticsViewModel.startDate = start
                        analyticsViewModel.endDate = end
                        showFilterView = false
                        analyticsViewModel.getAllTransaction(startDate: analyticsViewModel.startDate.toString, endDate: analyticsViewModel.endDate.toString)
                    }, onClose: {
                        showFilterView = false
                    })
                    .transition(.move(edge: .leading))
                }
            }
            .animation(.snappy, value: showFilterView)
            .navigationTitle(Text("Analytics"))
            .background(.surfaceBackground)
        }
        .background(.surfaceBackground)
    }
    
    
    private func getSelectedExpenditureByCategory(value: Int) {
        var cummulativeTotal = 0
        _ = analyticsViewModel.expenditurePercentageByCategory.first { expenditureByCategory in
            cummulativeTotal += Int(expenditureByCategory.percentage)
            if value <= cummulativeTotal {
                selectedExpenditureByCategory = expenditureByCategory
                return true
            }
            return false
        }
    }
}

#Preview {
    AnalyticsScreen()
}
