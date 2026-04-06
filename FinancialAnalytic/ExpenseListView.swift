import SwiftUI
import SwiftData

struct ExpenseListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]

    @State private var selectedDate = Date()
    @State private var selectedFilter = "Day"

    let filters = ["Day", "Today", "Week", "Month", "All"]

    private var filteredExpenses: [Expense] {
        let calendar = Calendar.current

        switch selectedFilter {
        case "Today":
            return expenses.filter { expense in
                calendar.isDateInToday(expense.date)
            }

        case "Week":
            return expenses.filter { expense in
                calendar.isDate(expense.date, equalTo: selectedDate, toGranularity: .weekOfYear)
            }

        case "Month":
            return expenses.filter { expense in
                calendar.isDate(expense.date, equalTo: selectedDate, toGranularity: .month)
            }

        case "All":
            return expenses

        default:
            return expenses.filter { expense in
                calendar.isDate(expense.date, inSameDayAs: selectedDate)
            }
        }
    }

    private var totalAmount: Double {
        filteredExpenses.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Filter", selection: $selectedFilter) {
                        ForEach(filters, id: \.self) { filter in
                            Text(filter)
                        }
                    }
                    .pickerStyle(.segmented)

                    if selectedFilter == "Day" || selectedFilter == "Week" || selectedFilter == "Month" {
                        DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                    }
                }

                if !expenses.isEmpty {
                    Section("Summary") {
                        HStack {
                            Text("Total Shown")
                                .fontWeight(.medium)

                            Spacer()

                            Text("$\(totalAmount, specifier: "%.2f")")
                                .fontWeight(.bold)
                        }
                    }
                }

                if expenses.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "tray")
                            .font(.title)
                            .foregroundStyle(.gray)

                        Text("No expenses logged yet")
                            .font(.headline)

                        Text("Add one from the Add tab")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                } else if filteredExpenses.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .font(.title)
                            .foregroundStyle(.gray)

                        Text("No expenses found")
                            .font(.headline)

                        Text("Try another filter or date")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                } else {
                    ForEach(filteredExpenses) { expense in
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
            }
            .navigationTitle("Expenses")
        }
    }

    private func deleteExpenses(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredExpenses[index])
            }
        }
    }
}

#Preview {
    ExpenseListView()
}
