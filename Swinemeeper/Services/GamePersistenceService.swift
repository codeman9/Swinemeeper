import Foundation

/// Errors that can occur during game persistence
enum GamePersistenceError: Error, Sendable {
    case encodingFailed
    case decodingFailed
    case fileOperationFailed
}

/// Service responsible for persisting game state to disk
final class GamePersistenceService: GamePersisting, @unchecked Sendable {
    private let fileManager: FileManager
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    private var saveFileURL: URL {
        let documentsDirectory = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!

        return documentsDirectory.appendingPathComponent("swinemeeper_save.json")
    }

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
        encoder.outputFormatting = .prettyPrinted
    }

    func save(_ gameState: GameState) async throws {
        let data: Data
        do {
            data = try encoder.encode(gameState)
        } catch {
            throw GamePersistenceError.encodingFailed
        }

        do {
            try data.write(to: saveFileURL, options: .atomic)
        } catch {
            throw GamePersistenceError.fileOperationFailed
        }
    }

    func load() async throws -> GameState? {
        guard fileManager.fileExists(atPath: saveFileURL.path) else {
            return nil
        }

        let data: Data
        do {
            data = try Data(contentsOf: saveFileURL)
        } catch {
            throw GamePersistenceError.fileOperationFailed
        }

        do {
            let gameState = try decoder.decode(GameState.self, from: data)
            return gameState
        } catch {
            throw GamePersistenceError.decodingFailed
        }
    }

    func deleteSavedGame() async throws {
        guard fileManager.fileExists(atPath: saveFileURL.path) else {
            return
        }

        do {
            try fileManager.removeItem(at: saveFileURL)
        } catch {
            throw GamePersistenceError.fileOperationFailed
        }
    }

    func hasSavedGame() async -> Bool {
        fileManager.fileExists(atPath: saveFileURL.path)
    }
}
