import Foundation

/// Protocol for managing game state transitions
protocol GameStateManaging: Sendable {
    /// Check if the game is won
    func checkWinCondition(board: Board) -> Bool

    /// Determine the new game status based on current state
    func determineStatus(board: Board, hitMine: Bool) -> GameStatus
}
