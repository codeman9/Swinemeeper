import Foundation
@testable import Swinemeeper

/// Mock cell marker for testing
final class MockCellMarker: CellMarking, @unchecked Sendable {
    var toggleFlagCalled = false
    var toggleFlagPosition: Position?
    var toggleFlagReturnValue: Board?

    var toggleQuestionMarkCalled = false
    var toggleQuestionMarkPosition: Position?
    var toggleQuestionMarkReturnValue: Board?

    var clearMarkCalled = false
    var clearMarkPosition: Position?
    var clearMarkReturnValue: Board?

    func toggleFlag(at position: Position, on board: Board) -> Board {
        toggleFlagCalled = true
        toggleFlagPosition = position
        return toggleFlagReturnValue ?? board
    }

    func toggleQuestionMark(at position: Position, on board: Board) -> Board {
        toggleQuestionMarkCalled = true
        toggleQuestionMarkPosition = position
        return toggleQuestionMarkReturnValue ?? board
    }

    func clearMark(at position: Position, on board: Board) -> Board {
        clearMarkCalled = true
        clearMarkPosition = position
        return clearMarkReturnValue ?? board
    }

    func reset() {
        toggleFlagCalled = false
        toggleFlagPosition = nil
        toggleFlagReturnValue = nil
        toggleQuestionMarkCalled = false
        toggleQuestionMarkPosition = nil
        toggleQuestionMarkReturnValue = nil
        clearMarkCalled = false
        clearMarkPosition = nil
        clearMarkReturnValue = nil
    }
}
