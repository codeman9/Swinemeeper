import Foundation

/// Represents a position on the board
struct Position: Hashable, Codable, Sendable {
    let row: Int
    let column: Int

    /// Returns all adjacent positions (including diagonals)
    func adjacentPositions(rows: Int, columns: Int) -> [Position] {
        var positions: [Position] = []

        for dRow in -1...1 {
            for dCol in -1...1 {
                if dRow == 0 && dCol == 0 { continue }

                let newRow = row + dRow
                let newCol = column + dCol

                if newRow >= 0 && newRow < rows && newCol >= 0 && newCol < columns {
                    positions.append(Position(row: newRow, column: newCol))
                }
            }
        }

        return positions
    }
}
