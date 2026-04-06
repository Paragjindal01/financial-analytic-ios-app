//
//  AnalyticsView.swift
//  FinancialAnalytic
//
//  Created by Guntash Brar on 2026-03-29.
//

import SwiftUI
import SwiftData
import Charts

struct CategoryTotal: Identifiable {
    let id = UUID()
    let category: String
    let total: Double
}

struct DailyTotal: Identifiable {
    let id = UUID()
    let date: Date
    let total: Double
}

struct AnalyticsView: View {
    @Query private var expenses: [Expense]

    var totalSpent: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    var categoryData: [CategoryTotal] {
        let grouped = Dictionary(grouping: expenses, by: { $0.category })

        return grouped.map { category, items in
            CategoryTotal(
                category: category,
                total: items.reduce(0) { $0 + $1.amount }
            )
        }
        .sorted { $0.total > $1.total }
    }

    var dailyData: [DailyTotal] {
        let calendar = Calendar.current

        let grouped = Dictionary(grouping: expenses) { expense in
            calendar.startOfDay(for: expense.date)
        }

        return grouped.map { date, items in
            DailyTotal(
                date: date,
                total: items.reduce(0) { $0 + $1.amount }
            )
        }
        .sorted { $0.date < $1.date }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Total Spending")
                            .font(.headline)

                        if expenses.isEmpty {
                            Text("$0.00")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        } else {
                            Text("$\(totalSpent, specifier: "%.2f")")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Spending by Category")
                            .font(.headline)

                        if categoryData.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "chart.pie")
                                    .font(.title)
                                    .foregroundStyle(.gray)

                                Text("No expense data available yet.")
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
                        } else {
                            Chart(categoryData) { item in
                                SectorMark(
                                    angle: .value("Amount", item.total)
                                )
                                .foregroundStyle(by: .value("Category", item.category))
                            }
                            .frame(height: 300)
                            .animation(.easeInOut(duration: 0.8), value: categoryData.count)

                            ForEach(categoryData) { item in
                                HStack {
                                    Text(item.category)

                                    Spacer()

                                    Text("$\(item.total, specifier: "%.2f")")
                                        .fontWeight(.medium)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Daily Spending Trend")
                            .font(.headline)

                        if dailyData.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.title)
                                    .foregroundStyle(.gray)

                                Text("No expense data available yet.")
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
                        } else {
                            Chart(dailyData) { item in
                                LineMark(
                                    x: .value("Date", item.date),
                                    y: .value("Total", item.total)
                                )

                                PointMark(
                                    x: .value("Date", item.date),
                                    y: .value("Total", item.total)
                                )
                            }
                            .frame(height: 300)
                            .animation(.easeInOut(duration: 0.8), value: dailyData.count)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
                .padding()
            }
            .navigationTitle("Analytics")
        }
    }
}

#Preview {
    AnalyticsView()
}
