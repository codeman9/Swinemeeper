import Foundation
@testable import Swinemeeper

/// Mock haptic provider for testing
final class MockHapticProvider: HapticProviding, @unchecked Sendable {
    var triggeredTypes: [HapticType] = []
    var triggerCalled: Bool { !triggeredTypes.isEmpty }
    var lastTriggeredType: HapticType? { triggeredTypes.last }

    func trigger(_ type: HapticType) {
        triggeredTypes.append(type)
    }

    func reset() {
        triggeredTypes.removeAll()
    }
}
