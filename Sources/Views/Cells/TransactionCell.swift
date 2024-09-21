//
//  TransactionCell.swift
//  MessageKit
//
//  Created by Tomas Shao on 2024/9/21.
//

import UIKit

public struct TransactionData {
    let date: Date
    let amount: String
    let currency: String
    let status: String
    let detailsURL: URL

    public init(date: Date, amount: String, currency: String, status: String, detailsURL: URL) {
        self.date = date
        self.amount = amount
        self.currency = currency
        self.status = status
        self.detailsURL = detailsURL
    }
}

open class TransactionCell: MessageContentCell {
    
    // MARK: - Properties
    
    public lazy var customContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    public lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    public lazy var transferLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    public lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    public lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemBlue
        label.text = "Tap to view transaction details"
        return label
    }()
    
    // MARK: - Lifecycle Methods
    
    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(customContentView)
        customContentView.addSubview(dateLabel)
        customContentView.addSubview(transferLabel)
        customContentView.addSubview(statusLabel)
        customContentView.addSubview(detailsLabel)
        setupConstraints()
    }
    
    open func setupConstraints() {
        customContentView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        transferLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            customContentView.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: 4),
            customContentView.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: -4),
            customContentView.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 4),
            customContentView.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -4),
            
            dateLabel.topAnchor.constraint(equalTo: customContentView.topAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: -16),
            
            transferLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            transferLabel.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor, constant: 16),
            transferLabel.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: -16),
            
            statusLabel.topAnchor.constraint(equalTo: transferLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: -16),
            
            detailsLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            detailsLabel.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor, constant: 16),
            detailsLabel.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: -16),
            detailsLabel.bottomAnchor.constraint(equalTo: customContentView.bottomAnchor, constant: -12)
        ])
    }
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        guard case .transaction(let transactionData) = message.kind else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: transactionData.date)
        transferLabel.text = "Transfer \(transactionData.amount) \(transactionData.currency)"
        statusLabel.text = transactionData.status
        statusLabel.textColor = transactionData.status.lowercased() == "success" ? .systemGreen : .systemRed
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        transferLabel.text = nil
        statusLabel.text = nil
    }
}
