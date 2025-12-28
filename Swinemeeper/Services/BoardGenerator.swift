import Foundation

/// Service responsible for generating and configuring game boards
final class BoardGenerator: BoardGenerating, @unchecked Sendable {
    private let randomGenerator: RandomNumberGenerating

    init(randomGenerator: RandomNumberGenerating = SystemRandomNumberGenerator()) {
        self.randomGenerator = randomGenerator
    }

    func placeMines(on board: Board, avoiding safePosition: Position) -> Board {
        var updatedBoard = board

        // Get positions to avoid (safe position and its neighbors)
        let safeZone = Set([safePosition] + safePosition.adjacentPositions(
            rows: board.rows,
            columns: board.columns
        ))

        // Get all valid positions for mines
        var availablePositions: [Position] = []
        for row in 0..<board.rows {
            for col in 0..<board.columns {
                let pos = Position(row: row, column: col)
                if !safeZone.contains(pos) {
                    availablePositions.append(pos)
                }
            }
        }

        // Shuffle and pick mine positions
        let shuffledPositions = randomGenerator.shuffled(availablePositions)
        let minePositions = Array(shuffledPositions.prefix(board.mineCount))

        // Place mines
        for position in minePositions {
            var cell = updatedBoard[position]
            cell.hasMine = true
            updatedBoard[position] = cell
        }

        updatedBoard.markMinesPlaced()
        return updatedBoard
    }

    func calculateAdjacentMines(on board: Board) -> Board {
        var updatedBoard = board

        for row in 0..<board.rows {
            for col in 0..<board.columns {
                let position = Position(row: row, column: col)
                var cell = updatedBoard[position]

                if !cell.hasMine {
                    let adjacentPositions = position.adjacentPositions(
                        rows: board.rows,
                        columns: board.columns
                    )

                    let mineCount = adjacentPositions.reduce(0) { count, pos in
                        count + (updatedBoard[pos].hasMine ? 1 : 0)
                    }

                    cell.adjacentMines = mineCount
                    updatedBoard[position] = cell
                }
            }
        }

        return updatedBoard
    }
}
