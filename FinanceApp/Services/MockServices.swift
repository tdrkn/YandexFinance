//
//  MockServices.swift
//  FinanceApp
//
//  Created by Danil on 6/11/25.
//

import Foundation

final class CategoriesService {
    func categories() async throws -> [Category] {
        return [
            Category(id: 1, name: "Fastfood", emoji: "🍔", direction: .outcome),
            Category(id: 2, name: "Salary", emoji: "💵", direction: .income),
            Category(id: 3, name: "Supermarkets", emoji: "🏪", direction: .outcome),
            Category(id: 4, name: "Transfers", emoji: "💳", direction: .income),
            Category(id: 5, name: "Transfers", emoji: "💳", direction: .outcome)
        ]
    }
        
    func categories(direction: Direction) async throws -> [Category] {
        let all = try await categories()
        return all.filter { $0.direction == direction }
    }
}

final class BankAccountsService {
    init() {
      currentAccount = BankAccount(
        id: 1,
        userId: 123,
        name: "Danil Rastiapin",
        balance: Decimal(string: "1234.56")!,
        currency: "RUB",
        createdAt: Date(),
        updatedAt: Date()
      )
    }
    
    func current() async throws -> BankAccount {
      return currentAccount
    }
    
    func update(_ account: BankAccount) async throws -> BankAccount {
      currentAccount = account
      return currentAccount
    }
    
    private var currentAccount: BankAccount
}

final class TransactionsService {
    private var store: [Transaction] = []

    func list(from: Date, to: Date) async throws -> [Transaction] {
        return store.filter { $0.transactionDate >= from && $0.transactionDate <= to }
    }

    func create(_ tx: Transaction) async throws -> Transaction {
        store.append(tx)
        return tx
    }

    func update(_ tx: Transaction) async throws -> Transaction {
        if let index = store.firstIndex(where: { $0.id == tx.id }) {
            store[index] = tx
        }
        return tx
    }

    func delete(id: Int) async throws {
        store.removeAll { $0.id == id }
    }
}





