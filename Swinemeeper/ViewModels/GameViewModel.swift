import Foundation
import Observation

/// Main view model for the Minesweeper game
@MainActor
@Observable
final class GameViewModel {
    // MARK: - Published State

    private(set) var gameState: GameState
    private(set) var showGameOverModal: Bool = false
    var isQuestionMarkModeEnabled: Bool {
        get { gameState.isQuestionMarkModeEnabled }
        set { gameState.isQuestionMarkModeEnabled = newValue }
    }

    // MARK: - Dependencies

    private let engine: GameEngineProtocol
    private let haptics: HapticProviding
    private let persistence: GamePersisting
    private let timer: TimerProviding

    // MARK: - Initialization

    init(
        difficulty: Difficulty = .easy,
        engine: GameEngineProtocol = GameEngine(),
        haptics: HapticProviding = HapticService(),
        persistence: GamePersisting = GamePersistenceService(),
        timer: TimerProviding? = nil
    ) {
        self.gameState = GameState(difficulty: difficulty)
        self.engine = engine
        self.haptics = haptics
        self.persistence = persistence
        self.timer = timer ?? GameTimer()
    }

    // MARK: - Computed Properties

    var board: Board { gameState.board }
    var status: GameStatus { gameState.status }
    var difficulty: Difficulty { gameState.difficulty }
    var remainingMines: Int { gameState.remainingMines }
    var formattedTime: String { gameState.formattedTime }
    var isGameOver: Bool { gameState.status.isGameOver }

    // MARK: - Game Actions

    /// Handle a tap on a cell
    func handleTap(at position: Position) {
        guard !isGameOver else { return }

        let cell = board[position]

        // Can't tap on flagged or revealed cells
        guard !cell.isFlagged && !cell.isRevealed else { return }

        // If question mark mode is enabled, toggle question mark instead
        if isQuestionMarkModeEnabled {
            handleQuestionMarkToggle(at: position)
            return
        }

        // If board hasn't been set up yet, this is the first tap
        if !board.minesPlaced {
            setupBoard(firstTapAt: position)
        }

        revealCell(at: position)
    }

    /// Handle a long press on a cell (flag toggle)
    func handleLongPress(at position: Position) {
        guard !isGameOver else { return }

        let cell = board[position]

        // Can't flag revealed cells
        guard !cell.isRevealed else { return }

        haptics.trigger(.medium)
        gameState.board = engine.toggleFlag(at: position, on: board)
        saveGame()
    }

    /// Toggle question mark on a cell
    func handleQuestionMarkToggle(at position: Position) {
        guard !isGameOver else { return }

        let cell = board[position]
        guard !cell.isRevealed else { return }

        haptics.trigger(.light)
        gameState.board = engine.toggleQuestionMark(at: position, on: board)
        saveGame()
    }

    /// Toggle question mark mode
    func toggleQuestionMarkMode() {
        isQuestionMarkModeEnabled.toggle()
        haptics.trigger(.selection)
    }

    /// Start a new game with the current difficulty
    func newGame() {
        timer.reset()
        gameState = GameState(difficulty: gameState.difficulty)
        showGameOverModal = false
        haptics.trigger(.medium)
        deleteCurrentSave()
    }

    /// Start a new game with a different difficulty
    func newGame(difficulty: Difficulty) {
        timer.reset()
        gameState = GameState(difficulty: difficulty)
        showGameOverModal = false
        haptics.trigger(.medium)
        deleteCurrentSave()
    }

    /// Dismiss the game over modal
    func dismissGameOverModal() {
        showGameOverModal = false
    }

    // MARK: - Persistence

    /// Try to load a saved game
    func loadSavedGame() async {
        do {
            if let savedState = try await persistence.load() {
                // Only load if game is not over
                if !savedState.status.isGameOver {
                    gameState = savedState
                    if savedState.status == .playing {
                        startTimer()
                    }
                }
            }
        } catch {
            // If loading fails, just start fresh
            print("Failed to load saved game: \(error)")
        }
    }

    /// Check if there's a saved game
    func hasSavedGame() async -> Bool {
        await persistence.hasSavedGame()
    }

    // MARK: - Private Methods

    private func setupBoard(firstTapAt position: Position) {
        // Place mines avoiding the first tap position
        var newBoard = engine.placeMines(on: board, avoiding: position)

        // Calculate adjacent mine counts
        newBoard = engine.calculateAdjacentMines(on: newBoard)

        gameState.board = newBoard
        gameState.status = .playing

        // Start the timer
        startTimer()
    }

    private func revealCell(at position: Position) {
        let result = engine.revealCell(at: position, on: board)

        gameState.board = result.board

        if result.hitMine {
            handleGameLost()
        } else {
            haptics.trigger(.light)

            // Check for win
            let newStatus = engine.determineStatus(board: gameState.board, hitMine: false)
            if newStatus == .won {
                handleGameWon()
            } else {
                saveGame()
            }
        }
    }

    private func handleGameWon() {
        gameState.status = .won
        timer.stop()
        haptics.trigger(.success)
        showGameOverModal = true
        deleteCurrentSave()
    }

    private func handleGameLost() {
        gameState.status = .lost
        gameState.board = engine.revealAllMines(on: board)
        timer.stop()
        haptics.trigger(.error)
        showGameOverModal = true
        deleteCurrentSave()
    }

    private func startTimer() {
        timer.start { [weak self] in
            self?.gameState.elapsedTime += 1
        }
    }

    private func saveGame() {
        Task {
            do {
                try await persistence.save(gameState)
            } catch {
                print("Failed to save game: \(error)")
            }
        }
    }

    private func deleteCurrentSave() {
        Task {
            try? await persistence.deleteSavedGame()
        }
    }
}
