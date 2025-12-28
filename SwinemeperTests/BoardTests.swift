import Testing
@testable import Swinemeeper

@Suite("Board Tests")
struct BoardTests {

    @Test("Creates board with correct dimensions")
    func createsCorrectDimensions() {
        let board = Board(rows: 9, columns: 9, mineCount: 10)

        #expect(board.rows == 9)
        #expect(board.columns == 9)
        #expect(board.mineCount == 10)
    }

    @Test("Creates board from difficulty")
    func createsFromDifficulty() {
        let easyBoard = Board(difficulty: .easy)
        #expect(easyBoard.rows == 9)
        #expect(easyBoard.columns == 9)
        #expect(easyBoard.mineCount == 10)

        let mediumBoard = Board(difficulty: .medium)
        #expect(mediumBoard.rows == 16)
        #expect(mediumBoard.columns == 16)
        #expect(mediumBoard.mineCount == 40)

        let hardBoard = Board(difficulty: .hard)
        #expect(hardBoard.rows == 16)
        #expect(hardBoard.columns == 30)
        #expect(hardBoard.mineCount == 99)
    }

    @Test("Subscript access works")
    func subscriptAccessWorks() {
        var board = Board(rows: 3, columns: 3, mineCount: 0)

        let cell = board[1, 1]
        #expect(cell.row == 1)
        #expect(cell.column == 1)

        var updatedCell = cell
        updatedCell.hasMine = true
        board[1, 1] = updatedCell

        #expect(board[1, 1].hasMine == true)
    }

    @Test("Position subscript access works")
    func positionSubscriptAccessWorks() {
        var board = Board(rows: 3, columns: 3, mineCount: 0)
        let position = Position(row: 2, column: 2)

        var cell = board[position]
        cell.hasMine = true
        board[position] = cell

        #expect(board[position].hasMine == true)
    }

    @Test("Validates positions correctly")
    func validatesPositions() {
        let board = Board(rows: 5, columns: 5, mineCount: 0)

        #expect(board.isValidPosition(Position(row: 0, column: 0)) == true)
        #expect(board.isValidPosition(Position(row: 4, column: 4)) == true)
        #expect(board.isValidPosition(Position(row: 2, column: 2)) == true)

        #expect(board.isValidPosition(Position(row: -1, column: 0)) == false)
        #expect(board.isValidPosition(Position(row: 0, column: -1)) == false)
        #expect(board.isValidPosition(Position(row: 5, column: 0)) == false)
        #expect(board.isValidPosition(Position(row: 0, column: 5)) == false)
    }

    @Test("Counts flagged cells")
    func countsFlaggedCells() {
        var board = Board(rows: 3, columns: 3, mineCount: 0)

        var cell1 = board[0, 0]
        cell1.state = .flagged
        board[0, 0] = cell1

        var cell2 = board[1, 1]
        cell2.state = .flagged
        board[1, 1] = cell2

        #expect(board.flaggedCount == 2)
    }

    @Test("Counts revealed cells")
    func countsRevealedCells() {
        var board = Board(rows: 3, columns: 3, mineCount: 0)

        var cell1 = board[0, 0]
        cell1.state = .revealed
        board[0, 0] = cell1

        var cell2 = board[1, 1]
        cell2.state = .revealed
        board[1, 1] = cell2

        var cell3 = board[2, 2]
        cell3.state = .revealed
        board[2, 2] = cell3

        #expect(board.revealedCount == 3)
    }

    @Test("Calculates non-mine cell count")
    func calculatesNonMineCellCount() {
        let board = Board(rows: 9, columns: 9, mineCount: 10)

        #expect(board.nonMineCellCount == 71)
    }

    @Test("Detects when all non-mines revealed")
    func detectsAllNonMinesRevealed() {
        var board = Board(rows: 2, columns: 2, mineCount: 1)

        // Place a mine
        var mineCell = board[0, 0]
        mineCell.hasMine = true
        board[0, 0] = mineCell

        // Reveal all non-mine cells
        for (row, col) in [(0, 1), (1, 0), (1, 1)] {
            var cell = board[row, col]
            cell.state = .revealed
            board[row, col] = cell
        }

        #expect(board.allNonMinesRevealed == true)
    }
}
