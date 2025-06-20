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
                    Image(systemName: "plus")
                    Text("Расходы")
                }
            TransactionListView(direction: .income)
                .tabItem {
                    Image(systemName: "minus")
                    Text("Доходы")
                }
            MyAccountView().tabItem {
                Image(systemName: "person.circle")
                Text("Счет")
            }
            CategoriesView().tabItem {
                Image(systemName: "list.bullet")
                Text("Категории")
            }
            SettingsView().tabItem {
                Image(systemName: "gearshape")
                Text("Настройки")
            }
        }
    }
}
