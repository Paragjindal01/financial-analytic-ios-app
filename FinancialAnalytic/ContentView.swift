//
//  ContentView.swift
//  FinancialAnalytic
//
//  Created by Parag Jindal on 2026-03-29.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house")
                }

            AddExpenseView()
                .tabItem {
                    Label("Add", systemImage: "plus.circle")
                }

            ExpenseListView()
                .tabItem {
                    Label("Expenses", systemImage: "list.bullet")
                }

            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.pie")
                }
        }
    }
}

#Preview {
    ContentView()
}
