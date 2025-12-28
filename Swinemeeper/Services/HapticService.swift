import UIKit

/// Service responsible for providing haptic feedback
@MainActor
final class HapticService: HapticProviding {
    private var lightGenerator: UIImpactFeedbackGenerator?
    private var mediumGenerator: UIImpactFeedbackGenerator?
    private var heavyGenerator: UIImpactFeedbackGenerator?
    private var notificationGenerator: UINotificationFeedbackGenerator?
    private var selectionGenerator: UISelectionFeedbackGenerator?

    init() {
        // Lazily prepare generators
        prepareGenerators()
    }

    private func prepareGenerators() {
        lightGenerator = UIImpactFeedbackGenerator(style: .light)
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
        notificationGenerator = UINotificationFeedbackGenerator()
        selectionGenerator = UISelectionFeedbackGenerator()

        lightGenerator?.prepare()
        mediumGenerator?.prepare()
        heavyGenerator?.prepare()
        notificationGenerator?.prepare()
        selectionGenerator?.prepare()
    }

    func trigger(_ type: HapticType) {
        switch type {
        case .light:
            lightGenerator?.impactOccurred()
        case .medium:
            mediumGenerator?.impactOccurred()
        case .heavy:
            heavyGenerator?.impactOccurred()
        case .success:
            notificationGenerator?.notificationOccurred(.success)
        case .warning:
            notificationGenerator?.notificationOccurred(.warning)
        case .error:
            notificationGenerator?.notificationOccurred(.error)
        case .selection:
            selectionGenerator?.selectionChanged()
        }
    }
}
