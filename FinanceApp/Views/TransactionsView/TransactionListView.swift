//
//  TransactionListView.swift
//  FinanceApp
//
//  Created by arxungo on 20.06.2025.
//

import SwiftUI



struct TransactionListView: View {
    let direction: Direction
    @State private var isShowingAdd = false
    @StateObject private var viewModel: TransactionListViewModel

    init(direction: Direction) {
        self.direction = direction
        _viewModel = StateObject(wrappedValue: TransactionListViewModel(direction: direction))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        HStack {
                            Text("Всего")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Spacer()
                            Text(rubFormatter.string(for: viewModel.totalAmount) ?? "")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                        )
                        .padding(.horizontal)
                        
                        VStack {
                            HStack {
                                Text("ОПЕРАЦИИ")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            List(viewModel.transactions) { tx in
                                NavigationLink {
                                    TransactionEditorView(transaction: tx)
                                } label: {
                                    TransactionRow(
                                        tx: tx,
                                        category: viewModel.category(for: tx)
                                    )
                                    .frame(height: 56)
                                }
                                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                            }
                            .listStyle(.plain)
                            .frame(height: CGFloat(viewModel.transactions.count) * 56-1)
                            .scrollContentBackground(.hidden)
//                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 18)
                }
                
                Button {
                    isShowingAdd = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundStyle(.background)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(Color(.accent)))
//                        .shadow(radius: 4)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                
            }
            .navigationTitle(direction == .income ? "Доходы сегодня" : "Расходы сегодня")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: HistoryScreen(direction: direction)) {
                        Image(systemName: "clock")
                            .font(.subheadline)
                            .foregroundColor(Color.blue)
                    }
                }
            }
            .sheet(isPresented: $isShowingAdd) {
                TransactionEditorView()
            }
            .tabItem {
                Label(
                    direction == .income ? "Доходы" : "Расходы",
                    systemImage: direction == .income ? "arrow.up.circle" : "arrow.down.circle"
                )
            }
        }
        
    }
}


fileprivate let rubFormatter: NumberFormatter = {
    let f = NumberFormatter()
    f.numberStyle       = .currency
    f.currencySymbol = "₽"
    f.maximumFractionDigits = 2
    f.minimumFractionDigits = 0
    f.groupingSeparator = " "
    f.locale = Locale(identifier: "ru_RU")
    return f
}()

struct TransactionRow: View {
    let tx: Transaction
    let category: Category

    var body: some View {
        HStack(spacing: 12) {
            Text(String(category.emoji))
                .font(.title3)
                .padding(CGFloat.init(3))
                .background(Color(Color.accentColor.opacity(0.2)))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 1) {
                Text(category.name)
                if let comment = tx.comment, !comment.isEmpty {
                    Text(comment)
                        .font(.caption)
                        .foregroundColor(.primary.opacity(0.5))
                        .lineLimit(1)
                }
            }
            Spacer()
            
            Text(rubFormatter.string(for: tx.amount) ?? "")
                .font(.callout)

        }
        .frame(height: 56, alignment: .center)

    }
}


#Preview {
  TransactionListView(direction: .income)
}
