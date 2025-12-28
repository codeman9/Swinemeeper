import Foundation

/// Protocol for persisting game state
protocol GamePersisting: Sendable {
    /// Save the current game state
    func save(_ gameState: GameState) async throws

    /// Load the saved game state
    func load() async throws -> GameState?

    /// Delete any saved game state
    func deleteSavedGame() async throws

    /// Check if a saved game exists
    func hasSavedGame() async -> Bool
}
