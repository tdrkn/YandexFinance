//
//  Category.swift
//  FinanceApp
//
//  Created by Danil on 6/10/25.
//

import Foundation

struct BankAccount: Identifiable, Codable {
    let id: Int
    let userId: Int
    let name: String
    let balance: Decimal
    let currency: String
    let createdAt: Date
    let updatedAt: Date
}
