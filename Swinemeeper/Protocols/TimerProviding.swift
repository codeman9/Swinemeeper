import Foundation

/// Protocol for timer functionality
@MainActor
protocol TimerProviding: AnyObject, Sendable {
    /// Start the timer with a callback for each tick
    func start(onTick: @escaping @MainActor () -> Void)

    /// Stop the timer
    func stop()

    /// Reset the timer
    func reset()

    /// Whether the timer is currently running
    var isRunning: Bool { get }
}
