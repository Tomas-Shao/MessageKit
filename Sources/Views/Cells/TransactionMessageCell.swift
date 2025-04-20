import UIKit

class TransactionMessageCell: MessageContentCell {
    private let currencyIconImageView = UIImageView()
    private let amountLabel = UILabel()
    private let chainIdLabel = UILabel()

    override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(currencyIconImageView)
        messageContainerView.addSubview(amountLabel)
        messageContainerView.addSubview(chainIdLabel)

        // 设置布局
        currencyIconImageView.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        chainIdLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            currencyIconImageView.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 12),
            currencyIconImageView.centerYAnchor.constraint(equalTo: messageContainerView.centerYAnchor),
            currencyIconImageView.widthAnchor.constraint(equalToConstant: 24),
            currencyIconImageView.heightAnchor.constraint(equalToConstant: 24),

            amountLabel.leadingAnchor.constraint(equalTo: currencyIconImageView.trailingAnchor, constant: 8),
            amountLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: 8),
            amountLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -12),

            chainIdLabel.leadingAnchor.constraint(equalTo: amountLabel.leadingAnchor),
            chainIdLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 4),
            chainIdLabel.trailingAnchor.constraint(equalTo: amountLabel.trailingAnchor),
            chainIdLabel.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: -8)
        ])
    }

	override func configure(
		with message: MessageType,
		at indexPath: IndexPath,
		and messagesCollectionView: MessagesCollectionView
	) {
		super.configure(with: message, at: indexPath, and: messagesCollectionView)

		guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
			fatalError(MessageKitError.nilMessagesDisplayDelegate)
		}

		if case .transaction(let transactionItem) = message.kind {
			let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
			currencyIconImageView.image = transactionItem.currencyIcon
			currencyIconImageView.tintColor = textColor

			amountLabel.text = transactionItem.amount
			amountLabel.font = UIFont.boldSystemFont(ofSize: 16)
			amountLabel.textColor = textColor

			chainIdLabel.text = chainName(for: transactionItem.chainId)
			chainIdLabel.font = UIFont.systemFont(ofSize: 12)
			chainIdLabel.textColor = textColor

			messageContainerView.layer.cornerRadius = 16
			messageContainerView.clipsToBounds = true
		}
	}
}

func chainName(for chainID: String) -> String {
	switch Int(chainID) {
	case 1:
		return "Ethereum Mainnet"
	case 3:
		return "Ropsten Testnet"
	case 4:
		return "Rinkeby Testnet"
	case 5:
		return "Goerli Testnet"
	case 42:
		return "Kovan Testnet"
	case 56:
		return "Binance Smart Chain"
	case 137:
		return "Polygon Mainnet"
	case 80001:
		return "Polygon Mumbai Testnet"
	case 11155111:
		return "Beagle Testnet"
	default:
		return "Unknown ChainID:" + chainID
	}
}
