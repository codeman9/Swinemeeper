import Foundation
@testable import Swinemeeper

/// Mock game persistence for testing
actor MockGamePersistence: GamePersisting {
    var savedGameState: GameState?
    var shouldThrowOnSave = false
    var shouldThrowOnLoad = false
    var shouldThrowOnDelete = false

    nonisolated func save(_ gameState: GameState) async throws {
        if await shouldThrowOnSave {
            throw GamePersistenceError.encodingFailed
        }
        await setSavedGameState(gameState)
    }

    nonisolated func load() async throws -> GameState? {
        if await shouldThrowOnLoad {
            throw GamePersistenceError.decodingFailed
        }
        return await getSavedGameState()
    }

    nonisolated func deleteSavedGame() async throws {
        if await shouldThrowOnDelete {
            throw GamePersistenceError.fileOperationFailed
        }
        await setSavedGameState(nil)
    }

    nonisolated func hasSavedGame() async -> Bool {
        await getSavedGameState() != nil
    }

    // Helper methods for actor isolation
    private func setSavedGameState(_ state: GameState?) {
        savedGameState = state
    }

    private func getSavedGameState() -> GameState? {
        savedGameState
    }

    func reset() {
        savedGameState = nil
        shouldThrowOnSave = false
        shouldThrowOnLoad = false
        shouldThrowOnDelete = false
    }
}
