import UIKit

open class TransactionMessageSizeCalculator: MessageSizeCalculator {
    open override func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        switch message.kind {
        case .transaction(let transactionItem):
            let maxWidth = messageContainerMaxWidth(for: message, at: indexPath)
            let amountWidth = transactionItem.amount.size(withAttributes: [.font: UIFont.boldSystemFont(ofSize: 16)]).width
            let chainIdWidth = transactionItem.chainId.size(withAttributes: [.font: UIFont.systemFont(ofSize: 12)]).width
            let iconWidth: CGFloat = 24 // 图标宽度
            let padding: CGFloat = 40 // 左右间距
            let totalWidth = min(maxWidth, max(amountWidth, chainIdWidth) + iconWidth + padding)
            let height: CGFloat = 60 // 固定高度
            return CGSize(width: totalWidth, height: height)
        default:
            return .zero
        }
    }
}