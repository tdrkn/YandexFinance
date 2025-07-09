//
//  HomeView.swift
//  FinanceApp
//
//  Created by arxungo on 19.06.2025.
//

import SwiftUI

struct BillView: View {
    @StateObject private var viewModel = BillViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Text("Баланс")
                    Spacer()
                    Text(rubFormatter.string(for: viewModel.account?.balance ?? 0) ?? "")
                }
                HStack {
                    Text("Валюта")
                    Spacer()
                    Text(viewModel.account?.currency ?? "")
                }
            }
            .task { viewModel.load() }
            .refreshable { viewModel.load() }
            .navigationTitle("Мои статьи")
        }
    }
}


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


#Preview {
    BillView()
}
