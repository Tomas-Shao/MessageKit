//
//  CallCell.swift
//  
//
//  Created by Tomas Shao on 2022/3/18.
//

import UIKit

public enum CallType {
    case audio
    case video
}

public struct CallData {
    public let type: CallType
    public let duration: TimeInterval
    public let isOutgoing: Bool

    public init(type: CallType, duration: TimeInterval, isOutgoing: Bool) {
        self.type = type
        self.duration = duration
        self.isOutgoing = isOutgoing
    }
}

open class CallCell: MessageContentCell {
    
    // MARK: - Public Properties
    
    public lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    public lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    // MARK: - Lifecycle Methods
    
    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(iconImageView)
        messageContainerView.addSubview(titleLabel)
        messageContainerView.addSubview(detailLabel)
        setupConstraints()
    }
    
    open func setupConstraints() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconImageView.leftAnchor.constraint(equalTo: messageContainerView.leftAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: messageContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: 8),
            titleLabel.rightAnchor.constraint(equalTo: messageContainerView.rightAnchor, constant: -10),

            detailLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10),
            detailLabel.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: -8),
            detailLabel.rightAnchor.constraint(equalTo: messageContainerView.rightAnchor, constant: -10)
        ])
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = nil
        detailLabel.text = nil
    }
    
    // MARK: - Configuration
    
    open override func configure(
        with message: MessageType,
        at indexPath: IndexPath,
        and messagesCollectionView: MessagesCollectionView
    ) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        guard case .call(let data) = message.kind else {
            return
        }

        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }

        let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
        titleLabel.textColor = textColor
        detailLabel.textColor = textColor

        configureCell(with: data)
    }
    
    private func configureCell(with callData: CallData) {
        switch callData.type {
        case .audio:
            iconImageView.image = UIImage(systemName: "phone.fill")
            titleLabel.text = "语音通话"
        case .video:
            iconImageView.image = UIImage(systemName: "video.fill")
            titleLabel.text = "视频通话"
        }

        let durationString = callData.duration.stringFromTimeInterval()
        let directionString = callData.isOutgoing ? "已拨出" : "已接听"
        
        detailLabel.text = "\(directionString) · \(durationString)"
    }
    
    // MARK: - Helper Methods
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        return formatter.string(from: date)
    }
}

// Helper extension to format time interval
extension TimeInterval {
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        let minutes = (time / 60) % 60
        let seconds = time % 60
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
}
