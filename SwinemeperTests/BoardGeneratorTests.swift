import Testing
@testable import Swinemeeper

@Suite("BoardGenerator Tests")
struct BoardGeneratorTests {

    @Test("Places correct number of mines")
    func placesCorrectNumberOfMines() {
        let generator = BoardGenerator()
        let board = Board(rows: 9, columns: 9, mineCount: 10)
        let safePosition = Position(row: 4, column: 4)

        let result = generator.placeMines(on: board, avoiding: safePosition)

        let mineCount = result.allCells.filter(\.hasMine).count
        #expect(mineCount == 10)
    }

    @Test("Avoids safe position when placing mines")
    func avoidsSafePosition() {
        let generator = BoardGenerator()
        let board = Board(rows: 9, columns: 9, mineCount: 10)
        let safePosition = Position(row: 4, column: 4)

        let result = generator.placeMines(on: board, avoiding: safePosition)

        #expect(result[safePosition].hasMine == false)
    }

    @Test("Avoids adjacent positions when placing mines")
    func avoidsAdjacentPositions() {
        let generator = BoardGenerator()
        let board = Board(rows: 9, columns: 9, mineCount: 10)
        let safePosition = Position(row: 4, column: 4)

        let result = generator.placeMines(on: board, avoiding: safePosition)

        let adjacentPositions = safePosition.adjacentPositions(rows: 9, columns: 9)
        for pos in adjacentPositions {
            #expect(result[pos].hasMine == false)
        }
    }

    @Test("Calculates adjacent mines correctly")
    func calculatesAdjacentMines() {
        let generator = BoardGenerator()
        var board = Board(rows: 3, columns: 3, mineCount: 0)

        // Place mines manually at corners
        var cell00 = board[0, 0]
        cell00.hasMine = true
        board[0, 0] = cell00

        var cell22 = board[2, 2]
        cell22.hasMine = true
        board[2, 2] = cell22

        let result = generator.calculateAdjacentMines(on: board)

        // Center cell should have 2 adjacent mines
        #expect(result[1, 1].adjacentMines == 2)

        // Cell at (0,1) should have 1 adjacent mine
        #expect(result[0, 1].adjacentMines == 1)

        // Cell at (1,0) should have 1 adjacent mine
        #expect(result[1, 0].adjacentMines == 1)
    }

    @Test("Marks mines as placed")
    func marksMinesAsPlaced() {
        let generator = BoardGenerator()
        let board = Board(rows: 5, columns: 5, mineCount: 5)

        #expect(board.minesPlaced == false)

        let result = generator.placeMines(on: board, avoiding: Position(row: 0, column: 0))

        #expect(result.minesPlaced == true)
    }

    @Test("Uses injected random generator")
    func usesInjectedRandomGenerator() {
        let mockRandom = MockRandomNumberGenerator()
        // Return positions in reverse order (deterministic)
        let generator = BoardGenerator(randomGenerator: mockRandom)

        let board = Board(rows: 3, columns: 3, mineCount: 1)
        let result = generator.placeMines(on: board, avoiding: Position(row: 1, column: 1))

        // Should have exactly 1 mine
        #expect(result.allCells.filter(\.hasMine).count == 1)
    }
}
