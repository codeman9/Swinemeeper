import Testing
@testable import Swinemeeper

@Suite("CellRevealer Tests")
struct CellRevealerTests {

    @Test("Reveals single cell")
    func revealsSingleCell() {
        let revealer = CellRevealer()
        var board = Board(rows: 3, columns: 3, mineCount: 0)

        // Set up cell with adjacent mines so it won't flood fill
        var cell = board[1, 1]
        cell.adjacentMines = 1
        board[1, 1] = cell

        let result = revealer.revealCell(at: Position(row: 1, column: 1), on: board)

        #expect(result.board[1, 1].isRevealed == true)
        #expect(result.hitMine == false)
        #expect(result.revealedPositions.contains(Position(row: 1, column: 1)))
    }

    @Test("Flood fills empty cells")
    func floodFillsEmptyCells() {
        let revealer = CellRevealer()
        let board = Board(rows: 3, columns: 3, mineCount: 0)

        // All cells have 0 adjacent mines, should flood fill entire board
        let result = revealer.revealCell(at: Position(row: 1, column: 1), on: board)

        // All 9 cells should be revealed
        #expect(result.revealedPositions.count == 9)
        for row in 0..<3 {
            for col in 0..<3 {
                #expect(result.board[row, col].isRevealed == true)
            }
        }
    }

    @Test("Detects hitting a mine")
    func detectsHittingMine() {
        let revealer = CellRevealer()
        var board = Board(rows: 3, columns: 3, mineCount: 0)

        var cell = board[1, 1]
        cell.hasMine = true
        board[1, 1] = cell

        let result = revealer.revealCell(at: Position(row: 1, column: 1), on: board)

        #expect(result.hitMine == true)
        #expect(result.board[1, 1].isRevealed == true)
    }

    @Test("Does not reveal flagged cells")
    func doesNotRevealFlaggedCells() {
        let revealer = CellRevealer()
        var board = Board(rows: 3, columns: 3, mineCount: 0)

        var cell = board[1, 1]
        cell.state = .flagged
        board[1, 1] = cell

        let result = revealer.revealCell(at: Position(row: 1, column: 1), on: board)

        #expect(result.board[1, 1].isFlagged == true)
        #expect(result.revealedPositions.isEmpty)
    }

    @Test("Stops flood fill at numbered cells")
    func stopsFloodFillAtNumberedCells() {
        let revealer = CellRevealer()
        var board = Board(rows: 3, columns: 3, mineCount: 0)

        // Set up a mine at corner
        var mineCell = board[0, 0]
        mineCell.hasMine = true
        board[0, 0] = mineCell

        // Calculate adjacent mines for cells next to mine
        var cell01 = board[0, 1]
        cell01.adjacentMines = 1
        board[0, 1] = cell01

        var cell10 = board[1, 0]
        cell10.adjacentMines = 1
        board[1, 0] = cell10

        var cell11 = board[1, 1]
        cell11.adjacentMines = 1
        board[1, 1] = cell11

        // Reveal from bottom right corner (empty)
        let result = revealer.revealCell(at: Position(row: 2, column: 2), on: board)

        // Should reveal some cells but not the mine
        #expect(result.board[0, 0].isRevealed == false)
        #expect(result.hitMine == false)
    }

    @Test("Reveals all mines")
    func revealsAllMines() {
        let revealer = CellRevealer()
        var board = Board(rows: 3, columns: 3, mineCount: 0)

        // Place mines at corners
        for (row, col) in [(0, 0), (0, 2), (2, 0), (2, 2)] {
            var cell = board[row, col]
            cell.hasMine = true
            board[row, col] = cell
        }

        let result = revealer.revealAllMines(on: board)

        #expect(result[0, 0].isRevealed == true)
        #expect(result[0, 2].isRevealed == true)
        #expect(result[2, 0].isRevealed == true)
        #expect(result[2, 2].isRevealed == true)
        // Non-mine cells should remain hidden
        #expect(result[1, 1].isRevealed == false)
    }

    @Test("Does not reveal flagged mines")
    func doesNotRevealFlaggedMines() {
        let revealer = CellRevealer()
        var board = Board(rows: 3, columns: 3, mineCount: 0)

        var cell = board[0, 0]
        cell.hasMine = true
        cell.state = .flagged
        board[0, 0] = cell

        let result = revealer.revealAllMines(on: board)

        #expect(result[0, 0].isFlagged == true)
        #expect(result[0, 0].isRevealed == false)
    }
}
