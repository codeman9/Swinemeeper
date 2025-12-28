import Foundation

/// Types of haptic feedback
enum HapticType: Sendable {
    case light
    case medium
    case heavy
    case success
    case warning
    case error
    case selection
}

/// Protocol for providing haptic feedback
protocol HapticProviding: Sendable {
    /// Trigger haptic feedback
    func trigger(_ type: HapticType)
}
