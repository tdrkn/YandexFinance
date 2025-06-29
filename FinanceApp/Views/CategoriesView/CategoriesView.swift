//
//  HomeView.swift
//  FinanceApp
//
//  Created by arxungo on 19.06.2025.
//

import SwiftUI



struct CategoriesView: View {
    
    @StateObject private var viewModel = CategoriesViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section(header:Text("СТАТЬИ")) {
                    ForEach(viewModel.filtered) { cat in
                        CategoryRow(category: cat)
                    }
                }
            }
            .navigationTitle("Мои статьи")
            .refreshable {}
            .searchable(text: $viewModel.searchText)
            .task { viewModel.load() }
            .refreshable { viewModel.load()}
        }
    }
}

struct CategoryRow: View {
    let category: Category

    var body: some View {
        HStack(spacing: 12) {
            Text(String(category.emoji))
                .font(.title3)
                .padding(3)
                .background(Color.accentColor.opacity(0.2))
                .clipShape(Circle())
            Text(category.name)
            Spacer()
        }
//        .frame(height: 20)
        ///пусть останется базовым...
    }
}

#Preview {
    CategoriesView()
}
