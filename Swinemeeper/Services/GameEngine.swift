import Foundation

/// Composed protocol representing all game engine capabilities
protocol GameEngineProtocol: BoardGenerating, CellRevealing, CellMarking, GameStateManaging, Sendable {}

/// Main game engine that composes all game-related services
final class GameEngine: GameEngineProtocol, @unchecked Sendable {
    private let boardGenerator: BoardGenerating
    private let cellRevealer: CellRevealing
    private let cellMarker: CellMarking
    private let stateManager: GameStateManaging

    init(
        boardGenerator: BoardGenerating = BoardGenerator(),
        cellRevealer: CellRevealing = CellRevealer(),
        cellMarker: CellMarking = CellMarker(),
        stateManager: GameStateManaging = GameStateManager()
    ) {
        self.boardGenerator = boardGenerator
        self.cellRevealer = cellRevealer
        self.cellMarker = cellMarker
        self.stateManager = stateManager
    }

    // MARK: - BoardGenerating

    func placeMines(on board: Board, avoiding safePosition: Position) -> Board {
        boardGenerator.placeMines(on: board, avoiding: safePosition)
    }

    func calculateAdjacentMines(on board: Board) -> Board {
        boardGenerator.calculateAdjacentMines(on: board)
    }

    // MARK: - CellRevealing

    func revealCell(at position: Position, on board: Board) -> RevealResult {
        cellRevealer.revealCell(at: position, on: board)
    }

    func revealAllMines(on board: Board) -> Board {
        cellRevealer.revealAllMines(on: board)
    }

    // MARK: - CellMarking

    func toggleFlag(at position: Position, on board: Board) -> Board {
        cellMarker.toggleFlag(at: position, on: board)
    }

    func toggleQuestionMark(at position: Position, on board: Board) -> Board {
        cellMarker.toggleQuestionMark(at: position, on: board)
    }

    func clearMark(at position: Position, on board: Board) -> Board {
        cellMarker.clearMark(at: position, on: board)
    }

    // MARK: - GameStateManaging

    func checkWinCondition(board: Board) -> Bool {
        stateManager.checkWinCondition(board: board)
    }

    func determineStatus(board: Board, hitMine: Bool) -> GameStatus {
        stateManager.determineStatus(board: board, hitMine: hitMine)
    }
}
