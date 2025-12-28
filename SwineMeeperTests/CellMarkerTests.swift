import Testing
@testable import Swinemeeper

@Suite("CellMarker Tests")
struct CellMarkerTests {

    @Test("Toggles flag on hidden cell")
    func togglesFlagOnHiddenCell() {
        let marker = CellMarker()
        let board = Board(rows: 3, columns: 3, mineCount: 0)

        let result = marker.toggleFlag(at: Position(row: 1, column: 1), on: board)

        #expect(result[1, 1].isFlagged == true)
    }

    @Test("Toggles flag off flagged cell")
    func togglesFlagOffFlaggedCell() {
        let marker = CellMarker()
        var board = Board(rows: 3, columns: 3, mineCount: 0)

        var cell = board[1, 1]
        cell.state = .flagged
        board[1, 1] = cell

        let result = marker.toggleFlag(at: Position(row: 1, column: 1), on: board)

        #expect(result[1, 1].isHidden == true)
    }

    @Test("Does not flag revealed cell")
    func doesNotFlagRevealedCell() {
        let marker = CellMarker()
        var board = Board(rows: 3, columns: 3, mineCount: 0)

        var cell = board[1, 1]
        cell.state = .revealed
        board[1, 1] = cell

        let result = marker.toggleFlag(at: Position(row: 1, column: 1), on: board)

        #expect(result[1, 1].isRevealed == true)
        #expect(result[1, 1].isFlagged == false)
    }

    @Test("Toggles question mark on hidden cell")
    func togglesQuestionMarkOnHiddenCell() {
        let marker = CellMarker()
        let board = Board(rows: 3, columns: 3, mineCount: 0)

        let result = marker.toggleQuestionMark(at: Position(row: 1, column: 1), on: board)

        #expect(result[1, 1].isQuestioned == true)
    }

    @Test("Toggles question mark off questioned cell")
    func togglesQuestionMarkOffQuestionedCell() {
        let marker = CellMarker()
        var board = Board(rows: 3, columns: 3, mineCount: 0)

        var cell = board[1, 1]
        cell.state = .questioned
        board[1, 1] = cell

        let result = marker.toggleQuestionMark(at: Position(row: 1, column: 1), on: board)

        #expect(result[1, 1].isHidden == true)
    }

    @Test("Flag replaces question mark")
    func flagReplacesQuestionMark() {
        let marker = CellMarker()
        var board = Board(rows: 3, columns: 3, mineCount: 0)

        var cell = board[1, 1]
        cell.state = .questioned
        board[1, 1] = cell

        let result = marker.toggleFlag(at: Position(row: 1, column: 1), on: board)

        #expect(result[1, 1].isFlagged == true)
    }

    @Test("Question mark replaces flag")
    func questionMarkReplacesFlag() {
        let marker = CellMarker()
        var board = Board(rows: 3, columns: 3, mineCount: 0)

        var cell = board[1, 1]
        cell.state = .flagged
        board[1, 1] = cell

        let result = marker.toggleQuestionMark(at: Position(row: 1, column: 1), on: board)

        #expect(result[1, 1].isQuestioned == true)
    }

    @Test("Clears mark from flagged cell")
    func clearsMarkFromFlaggedCell() {
        let marker = CellMarker()
        var board = Board(rows: 3, columns: 3, mineCount: 0)

        var cell = board[1, 1]
        cell.state = .flagged
        board[1, 1] = cell

        let result = marker.clearMark(at: Position(row: 1, column: 1), on: board)

        #expect(result[1, 1].isHidden == true)
    }

    @Test("Clears mark from questioned cell")
    func clearsMarkFromQuestionedCell() {
        let marker = CellMarker()
        var board = Board(rows: 3, columns: 3, mineCount: 0)

        var cell = board[1, 1]
        cell.state = .questioned
        board[1, 1] = cell

        let result = marker.clearMark(at: Position(row: 1, column: 1), on: board)

        #expect(result[1, 1].isHidden == true)
    }
}
