//
//  FinancialAnalyticApp.swift
//  FinancialAnalytic
//
//  Created by Parag Jindal on 2026-03-29.
//

import SwiftUI
import SwiftData

@main
struct FinanceAnalyticsAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Expense.self, Budget.self])
    }
}
