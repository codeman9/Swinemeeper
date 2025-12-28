import Testing
@testable import Swinemeeper

@Suite("GameStateManager Tests")
struct GameStateManagerTests {

    @Test("Detects win condition when all non-mines revealed")
    func detectsWinCondition() {
        let manager = GameStateManager()
        var board = Board(rows: 3, columns: 3, mineCount: 1)

        // Place mine at (0,0)
        var mineCell = board[0, 0]
        mineCell.hasMine = true
        board[0, 0] = mineCell

        // Reveal all non-mine cells
        for row in 0..<3 {
            for col in 0..<3 {
                if row != 0 || col != 0 {
                    var cell = board[row, col]
                    cell.state = .revealed
                    board[row, col] = cell
                }
            }
        }

        #expect(manager.checkWinCondition(board: board) == true)
    }

    @Test("Does not detect win when cells still hidden")
    func doesNotDetectWinWithHiddenCells() {
        let manager = GameStateManager()
        var board = Board(rows: 3, columns: 3, mineCount: 1)

        // Place mine at (0,0)
        var mineCell = board[0, 0]
        mineCell.hasMine = true
        board[0, 0] = mineCell

        // Reveal some but not all non-mine cells
        var cell = board[1, 1]
        cell.state = .revealed
        board[1, 1] = cell

        #expect(manager.checkWinCondition(board: board) == false)
    }

    @Test("Determines lost status when mine hit")
    func determinesLostStatus() {
        let manager = GameStateManager()
        let board = Board(rows: 3, columns: 3, mineCount: 1)

        let status = manager.determineStatus(board: board, hitMine: true)

        #expect(status == .lost)
    }

    @Test("Determines won status when all non-mines revealed")
    func determinesWonStatus() {
        let manager = GameStateManager()
        var board = Board(rows: 3, columns: 3, mineCount: 1)

        // Place mine at (0,0)
        var mineCell = board[0, 0]
        mineCell.hasMine = true
        board[0, 0] = mineCell

        // Reveal all non-mine cells
        for row in 0..<3 {
            for col in 0..<3 {
                if row != 0 || col != 0 {
                    var cell = board[row, col]
                    cell.state = .revealed
                    board[row, col] = cell
                }
            }
        }

        let status = manager.determineStatus(board: board, hitMine: false)

        #expect(status == .won)
    }

    @Test("Determines playing status when game in progress")
    func determinesPlayingStatus() {
        let manager = GameStateManager()
        var board = Board(rows: 3, columns: 3, mineCount: 1)

        // Place mine at (0,0)
        var mineCell = board[0, 0]
        mineCell.hasMine = true
        board[0, 0] = mineCell

        // Reveal just one cell
        var cell = board[1, 1]
        cell.state = .revealed
        board[1, 1] = cell

        let status = manager.determineStatus(board: board, hitMine: false)

        #expect(status == .playing)
    }
}
