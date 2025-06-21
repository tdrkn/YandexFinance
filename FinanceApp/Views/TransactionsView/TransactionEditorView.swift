//
//  AddTransactionView.swift
//  FinanceApp
//
//  Created by arxungo on 21.06.2025.
//

import SwiftUI

struct TransactionEditorView: View {
    var existing: Transaction? = nil

    private var categoriesService: CategoriesService

    @Environment(\.dismiss) private var dismiss

    @State private var selectedCategory: Category?
    @State private var amount: Decimal = 0
    @State private var date: Date = Date()
    @State private var comment: String = ""
    @State private var allCategories: [Category] = []

    init(transaction: Transaction? = nil,
         categoriesService: CategoriesService = CategoriesService()) {
        self.existing = transaction
        self.categoriesService = categoriesService
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink {
                        CategorySelectionView(selection: $selectedCategory)
                    } label: {
                        HStack {
                            Text("Статья")
                            Spacer()
                            Text(selectedCategory?.name ?? "Выбрать")
                                .foregroundColor(selectedCategory == nil ? .secondary : .primary)
                        }
                    }

                    HStack {
                        Text("Сумма")
                        Spacer()
                        TextField("0", value: $amount, formatter: NumericFormatter())
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("₽")
                    }
                    .padding(.vertical, 8)


                    DatePicker("Дата", selection: $date, displayedComponents: .date)

                    DatePicker("Время", selection: $date, displayedComponents: .hourAndMinute)

                    TextField("Комментарий", text: $comment)
                }
                
                if existing != nil {
                    Section {
                        Button("Удалить расход") {
                            // TODO: implement delete logic
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            
            .navigationTitle("Мои Расходы")
            .task {
                if allCategories.isEmpty {
                    do {
                        allCategories = try await categoriesService.categories()
                        if let tx = existing {
                            selectedCategory = allCategories.first { $0.id == tx.categoryId }
                        }
                    } catch {
                        
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                        .tint(.blue)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        // TODO: сохранить транзакцию
                        dismiss()
                    }
                    .tint(.blue)
                }
            }
        }
    }
}


fileprivate let NumericFormatter: () -> NumberFormatter = {
    let f = NumberFormatter()
    f.numberStyle = .decimal
    f.maximumFractionDigits = 2
    f.minimumFractionDigits = 0
    f.groupingSeparator = " "
    return f
}


struct CategorySelectionView: View {
    @Binding var selection: Category?
    var body: some View { Text("Категории…") }
}

#Preview {
    TransactionEditorView()
}
