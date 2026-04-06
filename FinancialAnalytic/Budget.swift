//
//  Budget.swift
//  FinancialAnalytic
//
//  Created by Guntash Brar on 2026-03-29.
//

import Foundation
import SwiftData

@Model
class Budget {
    var monthlyLimit: Double

    init(monthlyLimit: Double) {
        self.monthlyLimit = monthlyLimit
    }
}
