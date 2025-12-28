import Foundation

/// Result of revealing a cell
struct RevealResult: Sendable, Equatable {
    let board: Board
    let hitMine: Bool
    let revealedPositions: Set<Position>
}

/// Protocol for cell reveal operations
protocol CellRevealing: Sendable {
    /// Reveal a cell at the given position
    /// If the cell is empty (0 adjacent mines), recursively reveal neighbors
    func revealCell(at position: Position, on board: Board) -> RevealResult

    /// Reveal all mines on the board (called when game is lost)
    func revealAllMines(on board: Board) -> Board
}
