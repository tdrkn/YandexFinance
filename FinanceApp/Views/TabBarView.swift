//
//  TabBarView.swift
//  FinanceApp
//
//  Created by arxungo on 19.06.2025.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            TransactionListView(direction: .outcome)
                .tabItem {
                    Image("icon_expense")
                        .renderingMode(.template)
                    Text("Расходы")
                }
            TransactionListView(direction: .income)
                .tabItem {
                    Image("icon_income")
                        .renderingMode(.template)
                    Text("Доходы")
                }
            BillView().tabItem {
                Image("icon_account")
                    .renderingMode(.template)
                Text("Счет")
            }
            CategoriesView().tabItem {
                Image("icon_categories")
                    .renderingMode(.template)
                Text("Статьи")
            }
            SettingsView().tabItem {
                Image("icon_settings")
                    .renderingMode(.template)
                Text("Настройки")
            }
        }
    }
}
