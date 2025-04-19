import Foundation
import UIKit

/// A protocol used to represent the data for a call message (audio or video).
public protocol CallItem {
    /// A Boolean value indicating whether the call is audio-only.
    var isAudioOnly: Bool { get }

    /// The status text of the call (e.g., "Missed Call", "Call Duration: 2:30").
    var statusText: String { get }
}
