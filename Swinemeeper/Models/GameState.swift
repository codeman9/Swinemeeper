import Foundation

/// Represents the complete state of a game
struct GameState: Codable, Sendable, Equatable {
    var board: Board
    var status: GameStatus
    var difficulty: Difficulty
    var elapsedTime: TimeInterval
    var isQuestionMarkModeEnabled: Bool

    init(difficulty: Difficulty) {
        self.board = Board(difficulty: difficulty)
        self.status = .notStarted
        self.difficulty = difficulty
        self.elapsedTime = 0
        self.isQuestionMarkModeEnabled = false
    }

    var remainingMines: Int {
        board.mineCount - board.flaggedCount
    }

    var formattedTime: String {
        let totalSeconds = Int(elapsedTime)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
