import Foundation
@testable import Swinemeeper

/// Mock board generator for testing
final class MockBoardGenerator: BoardGenerating, @unchecked Sendable {
    var placeMinesCalled = false
    var placeMinesBoard: Board?
    var placeMinesSafePosition: Position?
    var placeMinesReturnValue: Board?

    var calculateAdjacentMinesCalled = false
    var calculateAdjacentMinesBoard: Board?
    var calculateAdjacentMinesReturnValue: Board?

    func placeMines(on board: Board, avoiding safePosition: Position) -> Board {
        placeMinesCalled = true
        placeMinesBoard = board
        placeMinesSafePosition = safePosition
        return placeMinesReturnValue ?? board
    }

    func calculateAdjacentMines(on board: Board) -> Board {
        calculateAdjacentMinesCalled = true
        calculateAdjacentMinesBoard = board
        return calculateAdjacentMinesReturnValue ?? board
    }

    func reset() {
        placeMinesCalled = false
        placeMinesBoard = nil
        placeMinesSafePosition = nil
        placeMinesReturnValue = nil
        calculateAdjacentMinesCalled = false
        calculateAdjacentMinesBoard = nil
        calculateAdjacentMinesReturnValue = nil
    }
}
