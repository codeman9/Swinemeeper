import Foundation
@testable import Swinemeeper

/// Mock random number generator for deterministic testing
final class MockRandomNumberGenerator: RandomNumberGenerating, @unchecked Sendable {
    var randomIntValues: [Int] = []
    private var randomIntIndex = 0

    var shuffleHandler: (([Any]) -> [Any])?

    func randomInt(in range: Range<Int>) -> Int {
        guard randomIntIndex < randomIntValues.count else {
            return range.lowerBound
        }
        let value = randomIntValues[randomIntIndex]
        randomIntIndex += 1
        return value
    }

    func shuffled<T>(_ array: [T]) -> [T] {
        if let handler = shuffleHandler {
            return handler(array as [Any]) as! [T]
        }
        // Return reversed for deterministic testing
        return array.reversed()
    }

    func reset() {
        randomIntIndex = 0
    }
}
