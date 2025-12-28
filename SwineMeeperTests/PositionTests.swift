import Testing
@testable import Swinemeeper

@Suite("Position Tests")
struct PositionTests {

    @Test("Returns all 8 adjacent positions for center cell")
    func returnsAllAdjacentPositionsForCenter() {
        let position = Position(row: 1, column: 1)
        let adjacent = position.adjacentPositions(rows: 3, columns: 3)

        #expect(adjacent.count == 8)
        #expect(adjacent.contains(Position(row: 0, column: 0)))
        #expect(adjacent.contains(Position(row: 0, column: 1)))
        #expect(adjacent.contains(Position(row: 0, column: 2)))
        #expect(adjacent.contains(Position(row: 1, column: 0)))
        #expect(adjacent.contains(Position(row: 1, column: 2)))
        #expect(adjacent.contains(Position(row: 2, column: 0)))
        #expect(adjacent.contains(Position(row: 2, column: 1)))
        #expect(adjacent.contains(Position(row: 2, column: 2)))
    }

    @Test("Returns 3 adjacent positions for corner cell")
    func returnsAdjacentPositionsForCorner() {
        let position = Position(row: 0, column: 0)
        let adjacent = position.adjacentPositions(rows: 3, columns: 3)

        #expect(adjacent.count == 3)
        #expect(adjacent.contains(Position(row: 0, column: 1)))
        #expect(adjacent.contains(Position(row: 1, column: 0)))
        #expect(adjacent.contains(Position(row: 1, column: 1)))
    }

    @Test("Returns 5 adjacent positions for edge cell")
    func returnsAdjacentPositionsForEdge() {
        let position = Position(row: 0, column: 1)
        let adjacent = position.adjacentPositions(rows: 3, columns: 3)

        #expect(adjacent.count == 5)
    }

    @Test("Position is hashable")
    func positionIsHashable() {
        let set: Set<Position> = [
            Position(row: 0, column: 0),
            Position(row: 0, column: 1),
            Position(row: 0, column: 0)  // duplicate
        ]

        #expect(set.count == 2)
    }
}
