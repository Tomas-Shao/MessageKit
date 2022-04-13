import Foundation
import UIKit

/// A protocol used to represent the data for a call message (audio or video).
public protocol CallItem {
    /// A Boolean value indicating whether the call is audio-only.
    var isAudioOnly: Bool { get }

    /// The status text of the call (e.g., "Missed Call", "Call Duration: 2:30").
    var statusText: String { get }

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
