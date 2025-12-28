import Foundation
@testable import Swinemeeper

/// Mock game engine combining all protocol mocks for testing
final class MockGameEngine: GameEngineProtocol, @unchecked Sendable {
    // BoardGenerating
    var placeMinesCalled = false
    var placeMinesReturnValue: Board?

    var calculateAdjacentMinesCalled = false
    var calculateAdjacentMinesReturnValue: Board?

    // CellRevealing
    var revealCellCalled = false
    var revealCellReturnValue: RevealResult?

    var revealAllMinesCalled = false
    var revealAllMinesReturnValue: Board?

    // CellMarking
    var toggleFlagCalled = false
    var toggleFlagReturnValue: Board?

    var toggleQuestionMarkCalled = false
    var toggleQuestionMarkReturnValue: Board?

    var clearMarkCalled = false
    var clearMarkReturnValue: Board?

    // GameStateManaging
    var checkWinConditionCalled = false
    var checkWinConditionReturnValue = false

    var determineStatusCalled = false
    var determineStatusReturnValue: GameStatus = .playing

    // BoardGenerating implementation
    func placeMines(on board: Board, avoiding safePosition: Position) -> Board {
        placeMinesCalled = true
        var result = placeMinesReturnValue ?? board
        result.markMinesPlaced()
        return result
    }

    func calculateAdjacentMines(on board: Board) -> Board {
        calculateAdjacentMinesCalled = true
        return calculateAdjacentMinesReturnValue ?? board
    }

    // CellRevealing implementation
    func revealCell(at position: Position, on board: Board) -> RevealResult {
        revealCellCalled = true
        if let returnValue = revealCellReturnValue {
            return returnValue
        }
        return RevealResult(board: board, hitMine: false, revealedPositions: [position])
    }

    func revealAllMines(on board: Board) -> Board {
        revealAllMinesCalled = true
        return revealAllMinesReturnValue ?? board
    }

    // CellMarking implementation
    func toggleFlag(at position: Position, on board: Board) -> Board {
        toggleFlagCalled = true
        return toggleFlagReturnValue ?? board
    }

    func toggleQuestionMark(at position: Position, on board: Board) -> Board {
        toggleQuestionMarkCalled = true
        return toggleQuestionMarkReturnValue ?? board
    }

    func clearMark(at position: Position, on board: Board) -> Board {
        clearMarkCalled = true
        return clearMarkReturnValue ?? board
    }

    // GameStateManaging implementation
    func checkWinCondition(board: Board) -> Bool {
        checkWinConditionCalled = true
        return checkWinConditionReturnValue
    }

    func determineStatus(board: Board, hitMine: Bool) -> GameStatus {
        determineStatusCalled = true
        return determineStatusReturnValue
    }

    func reset() {
        placeMinesCalled = false
        placeMinesReturnValue = nil
        calculateAdjacentMinesCalled = false
        calculateAdjacentMinesReturnValue = nil
        revealCellCalled = false
        revealCellReturnValue = nil
        revealAllMinesCalled = false
        revealAllMinesReturnValue = nil
        toggleFlagCalled = false
        toggleFlagReturnValue = nil
        toggleQuestionMarkCalled = false
        toggleQuestionMarkReturnValue = nil
        clearMarkCalled = false
        clearMarkReturnValue = nil
        checkWinConditionCalled = false
        checkWinConditionReturnValue = false
        determineStatusCalled = false
        determineStatusReturnValue = .playing
    }
}
