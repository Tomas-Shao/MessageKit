import Foundation
import UIKit

open class CallMessageSizeCalculator: MessageSizeCalculator {
    // MARK: Open

    open override func messageContainerMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
        let maxWidth = super.messageContainerMaxWidth(for: message, at: indexPath)
        let callInsets = messageLabelInsets(for: message)
        return maxWidth - callInsets.horizontal
    }

    open override func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        switch message.kind {
        case .call(let callItem):
            let maxWidth = messageContainerMaxWidth(for: message, at: indexPath)
            let textWidth = callItem.statusText.size(withAttributes: [.font: UIFont.systemFont(ofSize: 16)]).width
            let iconWidth: CGFloat = 20 // 图标宽度
            let padding: CGFloat = 40 // 左右间距
            let totalWidth = min(maxWidth, iconWidth + textWidth + padding)
            let height: CGFloat = 40 // 固定高度
            return CGSize(width: totalWidth, height: height)
        default:
            return .zero
        }
    }

    open override func configure(attributes: UICollectionViewLayoutAttributes) {
        super.configure(attributes: attributes)
        guard let attributes = attributes as? MessagesCollectionViewLayoutAttributes else { return }

        let dataSource = messagesLayout.messagesDataSource
        let indexPath = attributes.indexPath
        let message = dataSource.messageForItem(at: indexPath, in: messagesLayout.messagesCollectionView)

        attributes.messageLabelInsets = messageLabelInsets(for: message)
        attributes.messageLabelFont = messageLabelFont
    }

    // MARK: Public

    public var incomingMessageLabelInsets = UIEdgeInsets(top: 7, left: 18, bottom: 7, right: 14)
    public var outgoingMessageLabelInsets = UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 18)

    public var messageLabelFont = UIFont.preferredFont(forTextStyle: .body)

    // MARK: Internal

    internal func messageLabelInsets(for message: MessageType) -> UIEdgeInsets {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingMessageLabelInsets : incomingMessageLabelInsets
    }
}