import Foundation

/// Service responsible for game timer functionality
@MainActor
final class GameTimer: TimerProviding {
    private var timer: Timer?
    private var tickHandler: (@MainActor () -> Void)?
    private(set) var isRunning: Bool = false

    func start(onTick: @escaping @MainActor () -> Void) {
        guard !isRunning else { return }

        tickHandler = onTick
        isRunning = true

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tickHandler?()
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    func reset() {
        stop()
    }

    deinit {
        timer?.invalidate()
    }
}
