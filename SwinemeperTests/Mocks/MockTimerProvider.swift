import Foundation
@testable import Swinemeeper

/// Mock timer provider for testing
@MainActor
final class MockTimerProvider: TimerProviding {
    private(set) var isRunning: Bool = false
    var startCalled = false
    var stopCalled = false
    var resetCalled = false
    private var tickHandler: (@MainActor () -> Void)?

    func start(onTick: @escaping @MainActor () -> Void) {
        startCalled = true
        isRunning = true
        tickHandler = onTick
    }

    func stop() {
        stopCalled = true
        isRunning = false
    }

    func reset() {
        resetCalled = true
        isRunning = false
    }

    /// Simulate a timer tick for testing
    func simulateTick() {
        tickHandler?()
    }

    func resetMock() {
        startCalled = false
        stopCalled = false
        resetCalled = false
        isRunning = false
        tickHandler = nil
    }
}
