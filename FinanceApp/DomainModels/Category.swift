//
//  Category.swift
//  FinanceApp
//
//  Created by Danil on 6/10/25.
//

import Foundation

enum Direction {
    case income
    case outcome
}

struct Category: Identifiable {
    let id: Int
    let name: String
    let emoji: Character
    let direction: Direction
}
