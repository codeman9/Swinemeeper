import Foundation

/// Service responsible for revealing cells on the board
final class CellRevealer: CellRevealing, Sendable {

    func revealCell(at position: Position, on board: Board) -> RevealResult {
        var updatedBoard = board
        var revealedPositions = Set<Position>()
        var hitMine = false

        // Use iterative flood fill to avoid stack overflow on large boards
        var positionsToReveal = [position]

        while !positionsToReveal.isEmpty {
            let currentPosition = positionsToReveal.removeFirst()

            // Skip if already processed or not valid
            guard updatedBoard.isValidPosition(currentPosition) else { continue }

            let cell = updatedBoard[currentPosition]

            // Skip if already revealed or flagged
            guard cell.state == .hidden || cell.state == .questioned else { continue }

            // Reveal the cell
            var updatedCell = cell
            updatedCell.state = .revealed
            updatedBoard[currentPosition] = updatedCell
            revealedPositions.insert(currentPosition)

            // Check if hit a mine
            if cell.hasMine {
                hitMine = true
                continue
            }

            // If empty cell (0 adjacent mines), add neighbors to reveal
            if cell.adjacentMines == 0 {
                let neighbors = currentPosition.adjacentPositions(
                    rows: updatedBoard.rows,
                    columns: updatedBoard.columns
                )

                for neighbor in neighbors {
                    let neighborCell = updatedBoard[neighbor]
                    if neighborCell.state == .hidden || neighborCell.state == .questioned {
                        positionsToReveal.append(neighbor)
                    }
                }
            }
        }

        return RevealResult(
            board: updatedBoard,
            hitMine: hitMine,
            revealedPositions: revealedPositions
        )
    }

    func revealAllMines(on board: Board) -> Board {
        var updatedBoard = board

        for row in 0..<board.rows {
            for col in 0..<board.columns {
                let position = Position(row: row, column: col)
                var cell = updatedBoard[position]

                if cell.hasMine && cell.state != .flagged {
                    cell.state = .revealed
                    updatedBoard[position] = cell
                }
            }
        }

        return updatedBoard
    }
}
