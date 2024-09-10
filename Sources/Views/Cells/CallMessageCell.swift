//
//  File.swift
//  
//
//  Created by Tomas Shao on 2022/3/18.
//

import Foundation
import UIKit

open class CallMessageCall: MessageContentCell {

        /// The label that display contact name
    public lazy var nameLabel: UILabel = {
        let nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        nameLabel.textColor = .white
        return nameLabel
    }()

    public lazy var callIcon: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

        // MARK: - Methods
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes else {
            return
        }
        nameLabel.font = attributes.messageLabelFont
    }

    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(nameLabel)
        messageContainerView.addSubview(callIcon)
        setupConstraints()
    }

    open func setupConstraints() {
        NSLayoutConstraint.activate([
            callIcon.widthAnchor.constraint(equalToConstant: 24),
            callIcon.heightAnchor.constraint(equalToConstant: 24),
            callIcon.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 8),
            callIcon.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -4),
            callIcon.centerYAnchor.constraint(equalTo: messageContainerView.centerYAnchor),
            callIcon.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -10)
        ])
    }

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        let textColor = messagesCollectionView.messagesDisplayDelegate?.textColor(for: message, at: indexPath, in: messagesCollectionView)
        if case let .call(callItem) = message.kind {
            nameLabel.text = callItem.displayText
            nameLabel.textColor = textColor
            callIcon.image = UIImage.messageKitImageWith(type: callItem.hasVideo ? .video_call : .audio_call)
        }
    }

}
