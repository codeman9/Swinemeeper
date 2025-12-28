import Foundation

/// Represents the Minesweeper game board
struct Board: Codable, Sendable, Equatable {
    let rows: Int
    let columns: Int
    let mineCount: Int
    private(set) var cells: [[Cell]]
    private(set) var minesPlaced: Bool

    init(rows: Int, columns: Int, mineCount: Int) {
        self.rows = rows
        self.columns = columns
        self.mineCount = mineCount
        self.minesPlaced = false

        self.cells = (0..<rows).map { row in
            (0..<columns).map { column in
                Cell(row: row, column: column)
            }
        }
    }

    init(difficulty: Difficulty) {
        self.init(rows: difficulty.rows, columns: difficulty.columns, mineCount: difficulty.mineCount)
    }

    /// Access a cell at a specific position
    subscript(position: Position) -> Cell {
        get { cells[position.row][position.column] }
        set { cells[position.row][position.column] = newValue }
    }

    /// Access a cell at specific row and column
    subscript(row: Int, column: Int) -> Cell {
        get { cells[row][column] }
        set { cells[row][column] = newValue }
    }

    /// Check if a position is valid on the board
    func isValidPosition(_ position: Position) -> Bool {
        position.row >= 0 && position.row < rows &&
        position.column >= 0 && position.column < columns
    }

    /// Returns all cells as a flat array
    var allCells: [Cell] {
        cells.flatMap { $0 }
    }

    /// Count of flagged cells
    var flaggedCount: Int {
        allCells.filter(\.isFlagged).count
    }

    /// Count of revealed cells
    var revealedCount: Int {
        allCells.filter(\.isRevealed).count
    }

    /// Total non-mine cells
    var nonMineCellCount: Int {
        rows * columns - mineCount
    }

    /// Check if all non-mine cells are revealed
    var allNonMinesRevealed: Bool {
        revealedCount == nonMineCellCount
    }

    /// Update the board to mark mines as placed
    mutating func markMinesPlaced() {
        minesPlaced = true
    }

    /// Update cells with a new cell array
    mutating func updateCells(_ newCells: [[Cell]]) {
        cells = newCells
    }
}
