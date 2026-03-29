//
//  ExpenseListView.swift
//  FinancialAnalytic
//
//  Created by Parag Jindal on 2026-03-29.
//
import SwiftUI
import SwiftData

struct ExpenseListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]

    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses) { expense in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(expense.title)
                                .font(.headline)

                            Text(expense.category)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Text(expense.date, style: .date)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text("$\(expense.amount, specifier: "%.2f")")
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteExpenses)
            }
            .navigationTitle("Expenses")
        }
    }

    private func deleteExpenses(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(expenses[index])
            }
        }
    }
}

#Preview {
    ExpenseListView()
}
