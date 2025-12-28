import Testing
@testable import Swinemeeper

@Suite("GameViewModel Tests")
@MainActor
struct GameViewModelTests {

    @Test("Initializes with correct difficulty")
    func initializesWithCorrectDifficulty() {
        let viewModel = GameViewModel(difficulty: .medium)

        #expect(viewModel.difficulty == .medium)
        #expect(viewModel.board.rows == 16)
        #expect(viewModel.board.columns == 16)
        #expect(viewModel.board.mineCount == 40)
    }

    @Test("First tap sets up board")
    func firstTapSetupBoard() async {
        let mockEngine = MockGameEngine()
        let mockHaptics = MockHapticProvider()
        let mockPersistence = MockGamePersistence()
        let mockTimer = MockTimerProvider()

        let viewModel = GameViewModel(
            difficulty: .easy,
            engine: mockEngine,
            haptics: mockHaptics,
            persistence: mockPersistence,
            timer: mockTimer
        )

        viewModel.handleTap(at: Position(row: 0, column: 0))

        #expect(mockEngine.placeMinesCalled == true)
        #expect(mockEngine.calculateAdjacentMinesCalled == true)
        #expect(mockTimer.startCalled == true)
    }

    @Test("Long press toggles flag")
    func longPressTogglesFlag() async {
        let mockEngine = MockGameEngine()
        let mockHaptics = MockHapticProvider()
        let mockPersistence = MockGamePersistence()
        let mockTimer = MockTimerProvider()

        let viewModel = GameViewModel(
            difficulty: .easy,
            engine: mockEngine,
            haptics: mockHaptics,
            persistence: mockPersistence,
            timer: mockTimer
        )

        viewModel.handleLongPress(at: Position(row: 1, column: 1))

        #expect(mockEngine.toggleFlagCalled == true)
        #expect(mockHaptics.lastTriggeredType == .medium)
    }

    @Test("Question mark mode toggles")
    func questionMarkModeToggles() {
        let mockHaptics = MockHapticProvider()

        let viewModel = GameViewModel(
            difficulty: .easy,
            haptics: mockHaptics
        )

        #expect(viewModel.isQuestionMarkModeEnabled == false)

        viewModel.toggleQuestionMarkMode()

        #expect(viewModel.isQuestionMarkModeEnabled == true)
        #expect(mockHaptics.lastTriggeredType == .selection)
    }

    @Test("Tap in question mark mode places question mark")
    func tapInQuestionMarkModePlacesQuestionMark() async {
        let mockEngine = MockGameEngine()
        let mockHaptics = MockHapticProvider()
        let mockPersistence = MockGamePersistence()
        let mockTimer = MockTimerProvider()

        let viewModel = GameViewModel(
            difficulty: .easy,
            engine: mockEngine,
            haptics: mockHaptics,
            persistence: mockPersistence,
            timer: mockTimer
        )

        // First set up the board
        viewModel.handleTap(at: Position(row: 0, column: 0))
        mockEngine.reset()

        viewModel.toggleQuestionMarkMode()
        viewModel.handleTap(at: Position(row: 1, column: 1))

        #expect(mockEngine.toggleQuestionMarkCalled == true)
    }

    @Test("New game resets state")
    func newGameResetsState() async {
        let mockTimer = MockTimerProvider()

        let viewModel = GameViewModel(
            difficulty: .easy,
            timer: mockTimer
        )

        // Simulate some game progress
        viewModel.handleTap(at: Position(row: 0, column: 0))

        viewModel.newGame()

        #expect(viewModel.status == .notStarted)
        #expect(mockTimer.resetCalled == true)
        #expect(viewModel.showGameOverModal == false)
    }

    @Test("New game with different difficulty")
    func newGameWithDifferentDifficulty() {
        let viewModel = GameViewModel(difficulty: .easy)

        viewModel.newGame(difficulty: .hard)

        #expect(viewModel.difficulty == .hard)
        #expect(viewModel.board.rows == 16)
        #expect(viewModel.board.columns == 30)
    }

    @Test("Hitting mine ends game")
    func hittingMineEndsGame() async {
        let mockEngine = MockGameEngine()
        mockEngine.revealCellReturnValue = RevealResult(
            board: Board(difficulty: .easy),
            hitMine: true,
            revealedPositions: [Position(row: 0, column: 0)]
        )

        let mockHaptics = MockHapticProvider()
        let mockPersistence = MockGamePersistence()
        let mockTimer = MockTimerProvider()

        let viewModel = GameViewModel(
            difficulty: .easy,
            engine: mockEngine,
            haptics: mockHaptics,
            persistence: mockPersistence,
            timer: mockTimer
        )

        // Set up board first
        viewModel.handleTap(at: Position(row: 0, column: 0))

        // Now reveal cell that hits a mine
        viewModel.handleTap(at: Position(row: 1, column: 1))

        #expect(viewModel.status == .lost)
        #expect(viewModel.showGameOverModal == true)
        #expect(mockEngine.revealAllMinesCalled == true)
        #expect(mockTimer.stopCalled == true)
    }

    @Test("Winning game shows modal")
    func winningGameShowsModal() async {
        let mockEngine = MockGameEngine()
        mockEngine.determineStatusReturnValue = .won

        let mockHaptics = MockHapticProvider()
        let mockPersistence = MockGamePersistence()
        let mockTimer = MockTimerProvider()

        let viewModel = GameViewModel(
            difficulty: .easy,
            engine: mockEngine,
            haptics: mockHaptics,
            persistence: mockPersistence,
            timer: mockTimer
        )

        // Set up and play
        viewModel.handleTap(at: Position(row: 0, column: 0))
        viewModel.handleTap(at: Position(row: 1, column: 1))

        #expect(viewModel.status == .won)
        #expect(viewModel.showGameOverModal == true)
        #expect(mockHaptics.triggeredTypes.contains(.success))
    }

    @Test("Cannot tap after game over")
    func cannotTapAfterGameOver() async {
        let mockEngine = MockGameEngine()
        mockEngine.revealCellReturnValue = RevealResult(
            board: Board(difficulty: .easy),
            hitMine: true,
            revealedPositions: [Position(row: 0, column: 0)]
        )

        let viewModel = GameViewModel(
            difficulty: .easy,
            engine: mockEngine
        )

        // Set up and lose
        viewModel.handleTap(at: Position(row: 0, column: 0))
        viewModel.handleTap(at: Position(row: 1, column: 1))

        mockEngine.reset()

        // Try to tap again
        viewModel.handleTap(at: Position(row: 2, column: 2))

        #expect(mockEngine.revealCellCalled == false)
    }

    @Test("Timer increments elapsed time")
    func timerIncrementsElapsedTime() async {
        let mockTimer = MockTimerProvider()

        let viewModel = GameViewModel(
            difficulty: .easy,
            timer: mockTimer
        )

        // Start game
        viewModel.handleTap(at: Position(row: 0, column: 0))

        // Simulate timer ticks
        mockTimer.simulateTick()
        mockTimer.simulateTick()
        mockTimer.simulateTick()

        #expect(viewModel.formattedTime == "00:03")
    }

    @Test("Remaining mines counter decreases with flags")
    func remainingMinesDecreasesWithFlags() async {
        let mockEngine = MockGameEngine()
        let mockPersistence = MockGamePersistence()

        // Return a board with a flagged cell
        var flaggedBoard = Board(difficulty: .easy)
        var cell = flaggedBoard[1, 1]
        cell.state = .flagged
        flaggedBoard[1, 1] = cell
        mockEngine.toggleFlagReturnValue = flaggedBoard

        let viewModel = GameViewModel(
            difficulty: .easy,
            engine: mockEngine,
            persistence: mockPersistence
        )

        let initialRemaining = viewModel.remainingMines

        viewModel.handleLongPress(at: Position(row: 1, column: 1))

        #expect(viewModel.remainingMines == initialRemaining - 1)
    }
}
