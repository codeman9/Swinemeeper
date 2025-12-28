import Foundation

/// Service responsible for marking cells with flags or question marks
final class CellMarker: CellMarking, Sendable {

    func toggleFlag(at position: Position, on board: Board) -> Board {
        var updatedBoard = board
        var cell = updatedBoard[position]

        guard cell.state != .revealed else { return board }

        switch cell.state {
        case .hidden:
            cell.state = .flagged
        case .flagged:
            cell.state = .hidden
        case .questioned:
            cell.state = .flagged
        case .revealed:
            break
        }

        updatedBoard[position] = cell
        return updatedBoard
    }

    func toggleQuestionMark(at position: Position, on board: Board) -> Board {
        var updatedBoard = board
        var cell = updatedBoard[position]

        guard cell.state != .revealed else { return board }

        switch cell.state {
        case .hidden:
            cell.state = .questioned
        case .questioned:
            cell.state = .hidden
        case .flagged:
            cell.state = .questioned
        case .revealed:
            break
        }

        updatedBoard[position] = cell
        return updatedBoard
    }

    func clearMark(at position: Position, on board: Board) -> Board {
        var updatedBoard = board
        var cell = updatedBoard[position]

        guard cell.state == .flagged || cell.state == .questioned else { return board }

        cell.state = .hidden
        updatedBoard[position] = cell
        return updatedBoard
    }
}
