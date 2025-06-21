//
//  Transaction.swift
//  FinanceApp
//
//  Created by Danil on 6/10/25.
//

import Foundation

struct Transaction: Identifiable, Codable {
    let id: Int
    let accountId: Int
    let categoryId: Int
    let amount: Decimal
    let transactionDate: Date
    let comment: String?
    let createdAt: Date
    let updatedAt: Date
}

extension Transaction {
    nonisolated(unsafe) static let dateFormatter = ISO8601DateFormatter()
    
    static func parse(JsonObject: Any) -> Transaction? {
        guard let transactionDict = JsonObject as? [String: Any] else {
            return nil
        }
        guard let id = transactionDict["id"] as? Int,
              let accountId = transactionDict["accountId"] as? Int,
              let categoryId = transactionDict["categoryId"] as? Int,
              let amountStr = transactionDict["amount"] as? String,
              let amount = Decimal(string: amountStr),
              let dateStr = transactionDict["transactionDate"] as? String,
              let transactionDate = Self.dateFormatter.date(from: dateStr),
              let comment = transactionDict["comment"] as? String,
              let createdAtStr = transactionDict["createdAt"] as? String,
              let createdAt = Self.dateFormatter.date(from: createdAtStr),
              let updatedAtStr = transactionDict["updatedAt"] as? String,
              let updatedAt = Self.dateFormatter.date(from: updatedAtStr)
        else {
            return nil
        }
        return Transaction(id: id, accountId: accountId, categoryId: categoryId, amount: amount, transactionDate: transactionDate, comment: comment, createdAt: createdAt, updatedAt: updatedAt)
    }
    
    var jsonObject: Any {
        var dict: [String: Any] = [
            "id": id,
            "accountId": accountId,
            "categoryId": categoryId,
            "amount": "\(amount)",
            "transactionDate": Self.dateFormatter.string(from: transactionDate),
            "createdAt": Self.dateFormatter.string(from: createdAt),
            "updatedAt": Self.dateFormatter.string(from: updatedAt)
        ]
        if let comment = comment {
            dict["comment"] = comment
        } else {
            dict["comment"] = nil
        }
        return dict
    }
}

class TransactionFileCache {
    private(set) var transactions: [Transaction] = []
    
    func add(_ t: Transaction) {
        guard !transactions.contains(where: { $0.id == t.id }) else { return }
        transactions.append(t)
    }
    
    func remove(id: Int) {
        transactions.removeAll { $0.id == id }
    }
    
    func saveJSON(to filename: String) throws {
        let jsonObj = transactions.map { $0.jsonObject }
        let data = try! JSONSerialization.data(withJSONObject: jsonObj, options: [.prettyPrinted])
        let url = try fileURL(for: filename)
        try data.write(to: url)
    }
    
    func loadJSON(from filename: String) throws {
        let url = try fileURL(for: filename)
        let data = try Data(contentsOf: url)
        let raw = try JSONSerialization.jsonObject(with: data)
        guard let jsonObj = raw as? [[String: Any]] else {
            return
        }
        transactions = jsonObj.compactMap { Transaction.parse(JsonObject: $0) }
    }
    
    private func fileURL(for filename: String) throws -> URL {
        let trackFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return trackFile.appendingPathComponent(filename).appendingPathExtension("json")
    }
}
