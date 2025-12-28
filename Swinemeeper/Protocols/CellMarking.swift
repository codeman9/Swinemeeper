import Foundation

/// Protocol for marking cells with flags or question marks
protocol CellMarking: Sendable {
    /// Toggle flag on a cell
    func toggleFlag(at position: Position, on board: Board) -> Board

    /// Toggle question mark on a cell
    func toggleQuestionMark(at position: Position, on board: Board) -> Board

    /// Clear any mark from a cell (return to hidden state)
    func clearMark(at position: Position, on board: Board) -> Board
}
