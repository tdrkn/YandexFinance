//
//  AnalysisTransactionCell.swift
//  FinanceApp
//
//  Created by arxungo-dana on 10.07.2025.
//

import UIKit

final class AnalysisTransactionCell: UITableViewCell {
    private let emojiLabel = UILabel()
    private let nameLabel = UILabel()
    private let commentLabel = UILabel()
    private let amountLabel = UILabel()
    private let shareLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        emojiLabel.font = .systemFont(ofSize: 20)
        nameLabel.font = .systemFont(ofSize: 17)
        commentLabel.font = .systemFont(ofSize: 13)
        commentLabel.textColor = .secondaryLabel
        amountLabel.font = .systemFont(ofSize: 15)
        shareLabel.font = .systemFont(ofSize: 13)
        shareLabel.textColor = .secondaryLabel

        let vStack = UIStackView(arrangedSubviews: [nameLabel, commentLabel])
        vStack.axis = .vertical
        vStack.spacing = 2

        let rightStack = UIStackView(arrangedSubviews: [amountLabel, shareLabel])
        rightStack.axis = .vertical
        rightStack.alignment = .trailing

        let hStack = UIStackView(arrangedSubviews: [emojiLabel, vStack, rightStack])
        hStack.spacing = 8
        hStack.alignment = .center

        emojiLabel.setContentHuggingPriority(.required, for: .horizontal)
        rightStack.setContentHuggingPriority(.required, for: .horizontal)

        contentView.addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("coder err")
    }

    func configure(transaction: Transaction, category: Category, share: Double) {
        emojiLabel.text = String(category.emoji)
        nameLabel.text = category.name
        if let comment = transaction.comment, !comment.isEmpty {
            commentLabel.text = comment
            commentLabel.isHidden = false
        } else {
            commentLabel.isHidden = true
        }
        amountLabel.text = rubFormatter.string(for: transaction.amount)
        shareLabel.text = String(format: "%.1f%%", share)
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
