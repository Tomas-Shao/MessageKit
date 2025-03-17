//
//  CallMessageSizeCalculator.swift
//  MessageKit
//
//  Created by Tomas Shao on 2025/3/18.
//
import Foundation
import UIKit

open class CallMessageSizeCalculator: MessageSizeCalculator {
    open override func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        // 根据 CallCell 的内容调整这些值
        return CGSize(width: 250, height: 60)
    }
}
