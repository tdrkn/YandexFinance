//
//  HistoryScreen.swift
//  FinanceApp
//
//  Created by arxungo on 21.06.2025.
//
import SwiftUI


struct HistoryScreen: View {
    let direction: Direction          // .income or .outcome
    
    @State private var startDate: Date =
    Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    @State private var endDate: Date = Date()
    @State private var total: Decimal = 0
    @State private var transactions: [Transaction] = []
    @State private var categories: [Category] = []
    private let rubFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencySymbol = "₽"
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 0
        f.groupingSeparator = " "
        f.locale = Locale(identifier: "ru_RU")
        return f
    }()
    
    var body: some View {
        NavigationStack {
            
            Form {
                Section {
                    HStack {
                        Text("Начало")
                        Spacer()
                        DatePicker(
                            "",
                            selection: $startDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()
                    }
                    HStack {
                        Text("Конец")
                        Spacer()
                        DatePicker(
                            "",
                            selection: $endDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()
                    }
                    HStack {
                        Text("Сумма")
                            .foregroundColor(.primary)
                        Spacer()
                        Text(rubFormatter.string(for: total) ?? "")
                    }
                }
                Section(header: Text("ОПЕРАЦИИ").font(.caption).foregroundColor(.secondary)) {
                    ForEach(transactions) { tx in
                        NavigationLink {
                            TransactionEditorView(transaction: tx)
                        } label: {
                            TransactionRow(
                                tx: tx,
                                category: categories.first(where: { $0.id == tx.categoryId })
                                ?? Category(id: tx.categoryId, name: "Неизвестная категория", emoji: "❓", direction: direction)
                            )
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    }
                }
            }
            .navigationTitle("Моя история")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AnalysisView(direction: direction)) {
                        Image(systemName: "document")
                    }
                }
            }
        }
        
        .onChange(of: endDate) {
            if endDate < startDate { startDate = endDate }
        }
        .onChange(of: startDate) {
            if startDate > endDate { endDate = startDate }
        }
        .onAppear { fetchTransactions() }
        .onChange(of: startDate) { _ in fetchTransactions() }
        .onChange(of: endDate) { _ in fetchTransactions() }
    }
    
    private func fetchTransactions() {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: startDate)
        let endComponents = DateComponents(day: 1, second: -1)
        let end = calendar.date(byAdding: endComponents, to: calendar.startOfDay(for: endDate))!
        let txService = TransactionsService()
        let catService = CategoriesService()
        Task {
            do {
                async let fetchedCats = catService.categories(direction: direction)
                async let fetchedTxs = txService.list(from: start, to: end)
                let (cats, txs) = try await (fetchedCats, fetchedTxs)
                let filteredTxs = txs.filter { tx in
                    cats.contains(where: { $0.id == tx.categoryId })
                }
                categories = cats
                transactions = filteredTxs
                total = filteredTxs.reduce(Decimal(0)) { $0 + $1.amount }
            } catch {
                print("Failed to load history:", error)
            }
        }
    }
}

#Preview {
    HistoryScreen(direction: .outcome)
}
