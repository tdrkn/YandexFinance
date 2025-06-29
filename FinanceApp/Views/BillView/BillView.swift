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
//                    Spacer()
                }
                
                HStack {
                    Text("Валюта")
//                    Spacer()
                }
            }
            .navigationTitle("Моя история")
            .refreshable {}
        }
    }
}

#Preview {
    BillView()
}
