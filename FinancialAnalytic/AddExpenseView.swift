//
//  AddExpenseView.swift
//  FinancialAnalytic
//
//  Created by Guntash Brar on 2026-03-29.
//
import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var budgets: [Budget]

    @State private var title = ""
    @State private var amount = ""
    @State private var category = "Food"
    @State private var date = Date()
    @State private var budgetInput = ""
    @State private var showSavedMessage = false
    

    let categories = ["Food", "Rent", "Transportation", "Entertainment", "Utilities", "Other"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Expense Details") {
                    TextField("Title", text: $title)

                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)

                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { item in
                            Text(item)
                        }
                    }

                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }

                Section {
                    Button {
                        saveExpense()
                    } label: {
                        Text("Save Expense")
                            .frame(maxWidth: .infinity)
                    }
                }

                Section("Monthly Budget") {
                    TextField("Enter budget amount", text: $budgetInput)
                        .keyboardType(.decimalPad)

                    Button {
                        saveBudget()
                    } label: {
                        Text("Save Budget")
                            .frame(maxWidth: .infinity)
                    }

                    if let currentBudget = budgets.first {
                        Text("Current Budget: $\(currentBudget.monthlyLimit, specifier: "%.2f")")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            .navigationTitle("Add Expense")
            .alert("Saved", isPresented: $showSavedMessage) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Expense saved successfully.")
            }
        }
    }

    private func saveExpense() {
        guard let amountValue = Double(amount), !title.isEmpty else {
            return
        }

        let newExpense = Expense(
            title: title,
            amount: amountValue,
            category: category,
            date: date
        )

        withAnimation {
            modelContext.insert(newExpense)
        }

        title = ""
        amount = ""
        category = "Food"
        date = Date()
        showSavedMessage = true
    }

    private func saveBudget() {
        guard let budgetValue = Double(budgetInput) else {
            return
        }

        if let existingBudget = budgets.first {
            existingBudget.monthlyLimit = budgetValue
        } else {
            let newBudget = Budget(monthlyLimit: budgetValue)
            modelContext.insert(newBudget)
        }

        budgetInput = ""
    }
}

#Preview {
    AddExpenseView()
}
