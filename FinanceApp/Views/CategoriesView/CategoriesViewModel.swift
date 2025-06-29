//
//  CategoriesViewModel.swift
//  FinanceApp
//
//  Created by Danil on 6/29/25.
//

import Foundation

final class CategoriesViewModel: ObservableObject {
    @Published var categories : [Category] = []
    @Published var searchText: String = ""
    private let service = CategoriesService()
    
    var filtered: [Category]{
        guard !searchText.isEmpty else {return categories}
        return categories.filter {fuzzyMatch(text: $0.name, with: searchText)}
    }
    
    func load() {
        Task {
            do {
                categories = try await service.categories()
            } catch {
                ///ошибка
            }
        }
    }
    
    private func fuzzyMatch(text:String, with pattern: String ) -> Bool {
        let textLower = text.lowercased()
        let patLower = pattern.lowercased()
        var tIdx = textLower.startIndex
        var pIdx = patLower.startIndex
        while pIdx < patLower.endIndex {
            guard tIdx < textLower.endIndex else { return false }
            if textLower[tIdx] == patLower[pIdx] {
                pIdx = patLower.index(after: pIdx)
            }
            tIdx = textLower.index(after: tIdx)
        }
        return true
    }
}

