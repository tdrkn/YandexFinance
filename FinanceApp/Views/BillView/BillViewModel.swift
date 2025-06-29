//
//  BillViewModel.swift
//  FinanceApp
//
//  Created by Danil on 6/28/25.
//

import Foundation

final class BillViewModel: ObservableObject {
    @Published var account: BankAccount?
    @Published var isEditing: Bool = false
    @Published var isBalanceHidden: Bool = false
    
    private let service = BankAccountsService()
    
    @MainActor
    func load() {
        Task {
            do {
                account = try await service.current()
            }
        }
    }
    
    @MainActor
    func save(balance: Decimal, currency: String) {
        guard var acc = account else { return }
        acc = BankAccount(id: acc.id, userId: acc.userId, name: acc.name, balance: balance, currency: currency, createdAt: acc.createdAt, updatedAt: acc.updatedAt)
        Task {
            do {
                account = try await service.update(acc)
            }
        }
    }
}

