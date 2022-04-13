//
//  File.swift
//  
//
//  Created by Tomas Shao on 2022/3/18.
//

import Foundation

/// A protocol used to represent the data for an audio message.
public protocol CallItem {

    /// The url where the audio file is located.
    var hasVideo: Bool { get }

    /// The call duration in seconds.
    var duration: Int { get }

    var title: String { get }
}

extension CallItem {

    var displayText: String {
        duration <= 0 ? title : title + " " + secondsToHoursMinutesSeconds(duration)
    }

    private func secondsToHoursMinutesSeconds(_ seconds: Int) -> String {
        let value =  (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        if value.0 > 0 {
            return String(format: "%02i:%02i:%02i", value.0, value.1, value.2)
        } else {
            return String(format: "%02i:%02i", value.1, value.2)
        }
    }
}
