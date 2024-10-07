//
//  TransactionCell.swift
//  MessageKit
//
//  Created by Tomas Shao on 2024/9/21.
//

import UIKit

public struct TransactionData {
    public let amount: String
    public let currency: String
    public let status: String?
    public let detailsURL: URL
    public let chainId: Int

    public init(amount: String, currency: String, status: String?, detailsURL: URL, chainId: Int) {
        self.amount = amount
        self.currency = currency
        self.status = status
        self.detailsURL = detailsURL
        self.chainId = chainId
    }
}

open class TransactionCell: MessageContentCell {
    
    // MARK: - Properties
    
    public lazy var customContentView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        return view
    }()
    
    public lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
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
        label.textColor = .systemRed
        label.isHidden = true
        return label
    }()
    
    public lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemBlue
        label.text = "Tap to view details"
        label.isHidden = true
        return label
    }()
    
    // MARK: - Lifecycle Methods
    
    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(customContentView)
        customContentView.addSubview(iconImageView)
        customContentView.addSubview(transferLabel)
        customContentView.addSubview(statusLabel)
        customContentView.addSubview(detailsLabel)
        setupConstraints()
    }
    
    open func setupConstraints() {
        customContentView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        transferLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            customContentView.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: 4),
            customContentView.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: -4),
            customContentView.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 4),
            customContentView.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -4),
            
            iconImageView.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: transferLabel.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            transferLabel.topAnchor.constraint(equalTo: customContentView.topAnchor, constant: 16),
            transferLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            transferLabel.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: -16),

            statusLabel.topAnchor.constraint(equalTo: transferLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: transferLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: -16),
            
            detailsLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            detailsLabel.leadingAnchor.constraint(equalTo: transferLabel.leadingAnchor),
            detailsLabel.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: -16),
            detailsLabel.bottomAnchor.constraint(equalTo: customContentView.bottomAnchor, constant: -16)
        ])
    }
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        guard case .transaction(let transactionData) = message.kind else {
            return
        }

        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }

        let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
        transferLabel.textColor = textColor
        statusLabel.textColor = textColor
        detailsLabel.textColor = textColor

        transferLabel.text = "Transfer \(transactionData.amount) \(transactionData.currency)"
        
        if let status = transactionData.status, status.lowercased() == "cancel" {
            statusLabel.text = "Cancel"
            statusLabel.isHidden = false
            detailsLabel.isHidden = true
        } else {
            statusLabel.isHidden = true
            detailsLabel.isHidden = false
        }
        
        setIcon(for: transactionData.chainId)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        transferLabel.text = nil
        statusLabel.text = nil
        statusLabel.isHidden = true
        detailsLabel.isHidden = true
        iconImageView.image = nil
    }
    
    // MARK: - Helper Methods
    
    private func setIcon(for chainId: Int) {
        let iconName: String
        switch chainId {
        case 1:
            iconName = "ethereum_icon"
        case 56:
            iconName = "binance_icon"
        case 137:
            iconName = "polygon_icon"
        // 添加更多链的图标
        default:
            iconName = "default_icon"
        }
        
        iconImageView.image = UIImage(named: iconName)
    }
}
