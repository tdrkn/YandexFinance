//
//  AnalysisView.swift
//  FinanceApp
//
//  Created by arxungo-dana on 09.07.2025.
//

import SwiftUI


struct AnalysisView: UIViewControllerRepresentable {
    let direction: Direction

    func makeUIViewController(context: Context) -> AnalysisViewController {
        AnalysisViewController(direction: direction)
    }

    func updateUIViewController(_ uiViewController: AnalysisViewController, context: Context) {
        ///
    }
}


#Preview {
    AnalysisView(direction: .outcome)
}

