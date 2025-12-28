import Foundation

/// Protocol for generating and configuring game boards
protocol BoardGenerating: Sendable {
    /// Place mines on the board, avoiding the first tapped position and its neighbors
    func placeMines(
        on board: Board,
        avoiding safePosition: Position
    ) -> Board

    /// Calculate adjacent mine counts for all cells
    func calculateAdjacentMines(on board: Board) -> Board
}
