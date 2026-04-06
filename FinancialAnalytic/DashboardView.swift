//
//  Untitled.swift
//  FinancialAnalytic
//
//  Created by Guntash Brar on 2026-03-29.
//
import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query private var expenses: [Expense]
    @Query private var budgets: [Budget]

    var currentMonthExpenses: [Expense] {
        let calendar = Calendar.current
        let now = Date()

        return expenses.filter { expense in
            calendar.isDate(expense.date, equalTo: now, toGranularity: .month) &&
            calendar.isDate(expense.date, equalTo: now, toGranularity: .year)
        }
    }

    var totalSpent: Double {
        currentMonthExpenses.reduce(0) { $0 + $1.amount }
    }

    var budgetAmount: Double {
        budgets.first?.monthlyLimit ?? 0
    }

    var remainingBudget: Double {
        budgetAmount - totalSpent
    }

    var progressValue: Double {
        if budgetAmount == 0 { return 0 }
        return min(totalSpent / budgetAmount, 1.0)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Text("This Month")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("$\(totalSpent, specifier: "%.2f")")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Total Spending")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(18)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Budget Progress")
                            .font(.headline)

                        Text("Budget: $\(budgetAmount, specifier: "%.2f")")
                            .font(.subheadline)

                        ProgressView(value: progressValue)
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                            .animation(.easeInOut(duration: 0.5), value: progressValue)

                        Text("Remaining: $\(remainingBudget, specifier: "%.2f")")
                            .foregroundStyle(remainingBudget < 0 ? .red : .green)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(18)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Expenses")
                            .font(.headline)

                        if currentMonthExpenses.isEmpty {
                            Text("No expenses added yet.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(currentMonthExpenses.prefix(3)) { expense in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(expense.title)
                                            .fontWeight(.medium)
                                        Text(expense.category)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    Text("$\(expense.amount, specifier: "%.2f")")
                                        .fontWeight(.semibold)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(18)
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }
}

#Preview {
    DashboardView()
}
