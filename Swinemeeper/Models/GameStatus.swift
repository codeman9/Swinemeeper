import Foundation

/// Represents the current status of the game
enum GameStatus: Codable, Sendable, Equatable {
    case notStarted
    case playing
    case won
    case lost

    var isGameOver: Bool {
        self == .won || self == .lost
    }

    var isActive: Bool {
        self == .playing
    }
}
