import Foundation

/// Represents the difficulty levels for Minesweeper
enum Difficulty: String, CaseIterable, Codable, Sendable {
    case easy
    case medium
    case hard

    var displayName: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }

    var rows: Int {
        switch self {
        case .easy: return 9
        case .medium: return 16
        case .hard: return 16
        }
    }

    var columns: Int {
        switch self {
        case .easy: return 9
        case .medium: return 16
        case .hard: return 30
        }
    }

    var mineCount: Int {
        switch self {
        case .easy: return 10
        case .medium: return 40
        case .hard: return 99
        }
    }

    var description: String {
        "\(rows)×\(columns) • \(mineCount) mines"
    }
}
