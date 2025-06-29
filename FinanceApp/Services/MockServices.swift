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
            Category(id: 1, name: "Фастфуд", emoji: "🍔", direction: .outcome),
            Category(id: 2, name: "Зарплата", emoji: "💵", direction: .income),
            Category(id: 3, name: "Супермаркеты", emoji: "🏪", direction: .outcome),
            Category(id: 4, name: "Входящие переводы", emoji: "💳", direction: .income),
            Category(id: 5, name: "Исходящие переводы", emoji: "💳", direction: .outcome),
            Category(id: 6, name: "Развлечения", emoji: "🎉", direction: .outcome),
            Category(id: 7, name: "Транспорт", emoji: "🚌", direction: .outcome),
            Category(id: 8, name: "Аптека", emoji: "💊", direction: .outcome),
            Category(id: 9, name: "Кафе", emoji: "☕️", direction: .outcome),
            Category(id: 10, name: "Путешествия", emoji: "✈️", direction: .outcome),
            Category(id: 11, name: "Хозяйственные товары", emoji: "🛒", direction: .outcome),
            Category(id: 12, name: "Подписки", emoji: "🌐", direction: .outcome),
            Category(id: 13, name: "Образование", emoji: "🎓", direction: .outcome),
            Category(id: 14, name: "Подарки", emoji: "🎁", direction: .outcome),
            Category(id: 15, name: "Инвестиции", emoji: "📈", direction: .income)
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

    init() {
        let now = Date()
        store = [
            Transaction(
                id: 1,
                accountId: 1,
                categoryId: 1,
                amount: Decimal(string: "450.30")!,
                transactionDate: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 5))!,
                comment: "Burger Queen. Покупка бургера",
                createdAt: now,
                updatedAt: now
            ),
            Transaction(
                id: 2,
                accountId: 1,
                categoryId: 3,
                amount: Decimal(string: "2500.00")!,
                transactionDate: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 20))!,
                comment: "Пятерочка. Покупка моркови",
                createdAt: now,
                updatedAt: now
            ),
            Transaction(
                id: 3,
                accountId: 4,
                categoryId: 3,
                amount: Decimal(string: "439.18")!,
                transactionDate: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 3))!,
                comment: "",
                createdAt: now,
                updatedAt: now
            ),
            Transaction(
                id: 4,
                accountId: 1,
                categoryId: 4,
                amount: Decimal(string: "505.06")!,
                transactionDate: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 18))!,
                comment: "",
                createdAt: now,
                updatedAt: now
            ),
            Transaction(
                id: 5,
                accountId: 1,
                categoryId: 4,
                amount: Decimal(string: "450.00")!,
                transactionDate: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 1))!,
                comment: "",
                createdAt: now,
                updatedAt: now
            ),
            Transaction(
                id: 6,
                accountId: 1,
                categoryId: 5,
                amount: Decimal(string: "2500.00")!,
                transactionDate: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 15))!,
                comment: "Пятерочка. Покупка моркови",
                createdAt: now,
                updatedAt: now
            ),
            Transaction(
                id: 7,
                accountId: 1,
                categoryId: 1,
                amount: Decimal(string: "450.00")!,
                transactionDate: now,
                comment: "Burger Queen. Покупка бургера",
                createdAt: now,
                updatedAt: now
            ),
            Transaction(
                id: 8,
                accountId: 1,
                categoryId: 3,
                amount: Decimal(string: "2500.00")!,
                transactionDate: now,
                comment: "Пятерочка. Покупка моркови",
                createdAt: now,
                updatedAt: now
            ),
            Transaction(
                id: 9,
                accountId: 3,
                categoryId: 5,
                amount: Decimal(string: "450.00")!,
                transactionDate: now,
                comment: "Burger Queen. Покупка бургера",
                createdAt: now,
                updatedAt: now
            ),
            Transaction(
                id: 10,
                accountId: 1,
                categoryId: 3,
                amount: Decimal(string: "2500.00")!,
                transactionDate: now,
                comment: "Покупка ьогурта",
                createdAt: now,
                updatedAt: now
            ),
            Transaction(
                id: 11,
                accountId: 1,
                categoryId: 4,
                amount: Decimal(string: "2500.00")!,
                transactionDate: now,
                comment: "Входящий перевод от друга",
                createdAt: now,
                updatedAt: now
            ),
            Transaction(
                id: 12,
                accountId: 1,
                categoryId: 4,
                amount: Decimal(string: "2500.00")!,
                transactionDate: now,
                comment: "Еще один перевод от друга",
                createdAt: now,
                updatedAt: now
            ),
            Transaction(
                id: 13,
                accountId: 1,
                categoryId: 2,
                amount: Decimal(string: "50000.00")!,
                transactionDate: now,
                comment: "Доход с нелегального бизнеса",
                createdAt: now,
                updatedAt: now
            ),
            Transaction(
                id: 13,
                accountId: 1,
                categoryId: 5,
                amount: Decimal(string: "50000.00")!,
                transactionDate: now,
                comment: "Отправка денег за услуги",
                createdAt: now,
                updatedAt: now
            ),
            Transaction(
                id: 14,
                accountId: 1,
                categoryId: 4,
                amount: Decimal(string: "2500.00")!,
                transactionDate: now,
                comment: "Еще один перевод от друга",
                createdAt: now,
                updatedAt: now
            ),
            Transaction(
                id: 15,
                accountId: 1,
                categoryId: 2,
                amount: Decimal(string: "50000.00")!,
                transactionDate: now,
                comment: "Доход с нелегального бизнеса",
                createdAt: now,
                updatedAt: now
            ),
            Transaction(
                id: 16,
                accountId: 1,
                categoryId: 5,
                amount: Decimal(string: "50000.00")!,
                transactionDate: now,
                comment: "Отправка денег за услуги",
                createdAt: now,
                updatedAt: now
            )
        ]
    }

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





