import Foundation

/// Service responsible for managing game state transitions
final class GameStateManager: GameStateManaging, Sendable {

    func checkWinCondition(board: Board) -> Bool {
        // Win when all non-mine cells are revealed
        board.allNonMinesRevealed
    }

    func determineStatus(board: Board, hitMine: Bool) -> GameStatus {
        if hitMine {
            return .lost
        }

        if checkWinCondition(board: board) {
            return .won
        }

        return .playing
    }
}
