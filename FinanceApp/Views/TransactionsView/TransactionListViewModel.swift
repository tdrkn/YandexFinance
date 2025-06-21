//
//  TransactionListViewModel.swift
//  FinanceApp
//
//  Created by arxungo on 19.06.2025.
//

import Foundation


class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var totalAmount: Decimal = 0
    @Published var categories: [Category] = []
    
    private var allTransactions: [Transaction] = []
    
    private let pageSize = 20
    private var currentPage = 0
    
    let direction: Direction
    private let txService = TransactionsService()
    private let catService = CategoriesService()
    
    init(direction: Direction){
        self.direction = direction
        loadAllToday()
    }
    
    func loadAllToday() {
        let start = Calendar.current.startOfDay(for: Date())
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        
        Task {
            let allTx = try await txService.list(from: start, to: end)
            let categories = try await catService.categories(direction: direction)
            self.categories = categories
            let categoryIds = Set(categories.map(\.id))
            
            let filteredTx = allTx.filter { categoryIds.contains($0.categoryId) }
            
            allTransactions = filteredTx
            
            let sum = filteredTx.reduce(Decimal(0)) { result, tx in
                result + tx.amount
            }
            totalAmount = sum
            
            transactions = []
            currentPage = 0
            
            loadNextPage()
        }
    }
    private func loadNextPage() {
        let startIndex = currentPage * pageSize
        guard startIndex < allTransactions.count else { return }
        let endIndex = min(startIndex + pageSize, allTransactions.count)
        let nextSlice = allTransactions[startIndex..<endIndex]
        transactions.append(contentsOf: nextSlice)
        currentPage += 1
    }
    
    
    func category(for tx: Transaction) -> Category {
        categories.first { $0.id == tx.categoryId }
        ?? Category(id: 0, name: "Unknown", emoji: "❓", direction: direction)
    }
}
