//
//  AnalysisViewModel.swift
//  FinanceApp
//
//  Created by arxungo-dana on 09.07.2025.
//

import Foundation

final class AnalysisViewModel {
    private var allTransactions: [Transaction] = []
    private(set) var transactions: [Transaction] = []
    
    private(set) var categories: [Category] = []
    
    private(set) var total: Decimal = 0

    var startDate: Date
    var endDate: Date

    private let direction: Direction
    private let txService = TransactionsService()
    private let catService = CategoriesService()

    private let pageSize = 20
    private var currentPage = 0

    init(direction: Direction) {
        self.direction = direction
        self.startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        self.endDate = Date()
    }

    
    func reload(completion: @escaping () -> Void) {
        Task {
            await loadAll()
            await MainActor.run { completion() }
        }
    }

    @MainActor
    private func loadAll() async {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: startDate)
        let end = calendar.date(byAdding: DateComponents(day: 1, second: -1),
                                to: calendar.startOfDay(for: endDate))!
        do {
            async let fetchedCats = catService.categories(direction: direction)
            async let fetchedTxs = txService.list(from: start, to: end)
            let (cats, txs) = try await (fetchedCats, fetchedTxs)
            categories = cats
            let filtered = txs.filter { tx in
                cats.contains(where: { $0.id == tx.categoryId })
            }
            allTransactions = filtered
            total = filtered.reduce(Decimal(0)) { $0 + $1.amount }
            transactions = []
            currentPage = 0
            loadNextPage()
        } catch {
            print("Failed to load analytics:", error)
        }
    }

    func loadNextPage() {
        let startIndex = currentPage * pageSize
        guard startIndex < allTransactions.count else { return }
        let endIndex = min(startIndex + pageSize, allTransactions.count)
        transactions.append(contentsOf: allTransactions[startIndex..<endIndex])
        currentPage += 1
    }

    func category(for tx: Transaction) -> Category {
        categories.first { $0.id == tx.categoryId } ??
        Category(id: tx.categoryId, name: "Неизвестная категория", emoji: "❓", direction: direction)
    }

    func share(for tx: Transaction) -> Double {
        guard total != 0 else { return 0 }
        let n = (tx.amount as NSDecimalNumber).doubleValue
        let d = (total as NSDecimalNumber).doubleValue
        return n / d * 100
    }
}
