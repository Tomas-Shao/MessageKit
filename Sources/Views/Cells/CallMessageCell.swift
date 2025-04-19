import UIKit

class CallMessageCell: MessageContentCell {
    private let iconImageView = UIImageView()
    private let statusLabel = UILabel()

    override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(iconImageView)
        messageContainerView.addSubview(statusLabel)

        // 设置布局
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: messageContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),

            statusLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            statusLabel.centerYAnchor.constraint(equalTo: messageContainerView.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -12),
            statusLabel.widthAnchor.constraint(lessThanOrEqualTo: messageContainerView.widthAnchor, constant: -40)
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

        if case .call(let callItem) = message.kind {
            let iconImage = callItem.isAudioOnly ? UIImage(systemName: "phone.fill") : UIImage(systemName: "video.fill")
            iconImageView.image = iconImage

            statusLabel.text = callItem.statusText
            statusLabel.font = UIFont.systemFont(ofSize: 16)
            statusLabel.numberOfLines = 0
            statusLabel.lineBreakMode = .byWordWrapping

            let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
            statusLabel.textColor = textColor
			iconImageView.tintColor = textColor

			NSLayoutConstraint.deactivate([
				iconImageView.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 12),
				statusLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8)
			])
			NSLayoutConstraint.activate([
				statusLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -12),
				iconImageView.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -8)
			])
        }
    }
}
