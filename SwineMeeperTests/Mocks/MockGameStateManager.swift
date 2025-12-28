import Foundation
@testable import Swinemeeper

/// Mock game state manager for testing
final class MockGameStateManager: GameStateManaging, @unchecked Sendable {
    var checkWinConditionCalled = false
    var checkWinConditionBoard: Board?
    var checkWinConditionReturnValue = false

    var determineStatusCalled = false
    var determineStatusBoard: Board?
    var determineStatusHitMine: Bool?
    var determineStatusReturnValue: GameStatus = .playing

    func checkWinCondition(board: Board) -> Bool {
        checkWinConditionCalled = true
        checkWinConditionBoard = board
        return checkWinConditionReturnValue
    }

    func determineStatus(board: Board, hitMine: Bool) -> GameStatus {
        determineStatusCalled = true
        determineStatusBoard = board
        determineStatusHitMine = hitMine
        return determineStatusReturnValue
    }

    func reset() {
        checkWinConditionCalled = false
        checkWinConditionBoard = nil
        checkWinConditionReturnValue = false
        determineStatusCalled = false
        determineStatusBoard = nil
        determineStatusHitMine = nil
        determineStatusReturnValue = .playing
    }
}
