import Foundation

/// Represents a single cell on the Minesweeper board
struct Cell: Identifiable, Codable, Sendable, Equatable {
    let id: UUID
    let row: Int
    let column: Int
    var hasMine: Bool
    var adjacentMines: Int
    var state: CellState

    init(
        id: UUID = UUID(),
        row: Int,
        column: Int,
        hasMine: Bool = false,
        adjacentMines: Int = 0,
        state: CellState = .hidden
    ) {
        self.id = id
        self.row = row
        self.column = column
        self.hasMine = hasMine
        self.adjacentMines = adjacentMines
        self.state = state
    }

    var isRevealed: Bool {
        state == .revealed
    }

    var isFlagged: Bool {
        state == .flagged
    }

    var isQuestioned: Bool {
        state == .questioned
    }

    var isHidden: Bool {
        state == .hidden
    }

    var isEmpty: Bool {
        !hasMine && adjacentMines == 0
    }
}

extension Cell {
    /// Returns the position as a tuple
    var position: Position {
        Position(row: row, column: column)
    }
}
