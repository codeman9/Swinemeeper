import Foundation
@testable import Swinemeeper

/// Mock cell revealer for testing
final class MockCellRevealer: CellRevealing, @unchecked Sendable {
    var revealCellCalled = false
    var revealCellPosition: Position?
    var revealCellBoard: Board?
    var revealCellReturnValue: RevealResult?

    var revealAllMinesCalled = false
    var revealAllMinesBoard: Board?
    var revealAllMinesReturnValue: Board?

    func revealCell(at position: Position, on board: Board) -> RevealResult {
        revealCellCalled = true
        revealCellPosition = position
        revealCellBoard = board

        if let returnValue = revealCellReturnValue {
            return returnValue
        }

        return RevealResult(board: board, hitMine: false, revealedPositions: [position])
    }

    func revealAllMines(on board: Board) -> Board {
        revealAllMinesCalled = true
        revealAllMinesBoard = board
        return revealAllMinesReturnValue ?? board
    }

    func reset() {
        revealCellCalled = false
        revealCellPosition = nil
        revealCellBoard = nil
        revealCellReturnValue = nil
        revealAllMinesCalled = false
        revealAllMinesBoard = nil
        revealAllMinesReturnValue = nil
    }
}
