import Foundation

/// Protocol for random number generation - enables testing with deterministic values
protocol RandomNumberGenerating: Sendable {
    /// Generate a random integer in the given range
    func randomInt(in range: Range<Int>) -> Int

    /// Shuffle an array
    func shuffled<T>(_ array: [T]) -> [T]
}

/// Default implementation using system random
final class SystemRandomNumberGenerator: RandomNumberGenerating, @unchecked Sendable {
    func randomInt(in range: Range<Int>) -> Int {
        Int.random(in: range)
    }

    func shuffled<T>(_ array: [T]) -> [T] {
        array.shuffled()
    }
}
