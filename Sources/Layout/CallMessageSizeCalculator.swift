//
//  File.swift
//  
//
//  Created by Tomas Shao on 2022/3/18.
//

import Foundation
import UIKit

open class CallMessageSizeCalculator: MessageSizeCalculator {

    public var incomingMessageNameLabelInsets = UIEdgeInsets(top: 7, left: 46, bottom: 7, right: 20)
    public var outgoingMessageNameLabelInsets = UIEdgeInsets(top: 7, left: 41, bottom: 7, right: 20)
    public var callLabelFont = UIFont.preferredFont(forTextStyle: .body)

    internal func callLabelInsets(for message: MessageType) -> UIEdgeInsets {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingMessageNameLabelInsets : incomingMessageNameLabelInsets
    }

    open override func messageContainerMaxWidth(for message: MessageType) -> CGFloat {
        let maxWidth = super.messageContainerMaxWidth(for: message)
        let textInsets = callLabelInsets(for: message)
        return maxWidth - textInsets.horizontal
    }

    open override func messageContainerSize(for message: MessageType) -> CGSize {
        let maxWidth = messageContainerMaxWidth(for: message)

        var messageContainerSize: CGSize
        let attributedText: NSAttributedString

        switch message.kind {
        case .call(let item):
            attributedText = NSAttributedString(string: item.displayText , attributes: [.font: callLabelFont])
        default:
            fatalError("messageContainerSize received unhandled MessageDataType: \(message.kind)")
        }

        messageContainerSize = labelSize(for: attributedText, considering: maxWidth)

        let messageInsets = callLabelInsets(for: message)
        messageContainerSize.width += messageInsets.horizontal
        messageContainerSize.height += messageInsets.vertical

        return messageContainerSize
    }

    open override func configure(attributes: UICollectionViewLayoutAttributes) {
        super.configure(attributes: attributes)
        guard let attributes = attributes as? MessagesCollectionViewLayoutAttributes else { return }
        attributes.messageLabelFont = callLabelFont
    }

}
