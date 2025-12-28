import Foundation

/// Represents the visual state of a cell
enum CellState: Codable, Sendable, Equatable {
    case hidden
    case revealed
    case flagged
    case questioned
}
