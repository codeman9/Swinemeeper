# Swinemeeper

A Minesweeper clone for iOS built with SwiftUI and Swift 6.

## Features

- **Three Difficulty Levels**:
  - Easy: 9×9 grid with 10 mines
  - Medium: 16×16 grid with 40 mines
  - Hard: 16×30 grid with 99 mines

- **Classic Gameplay**:
  - Tap to reveal cells
  - Long press to flag mines
  - Question mark mode toggle for uncertain cells
  - First tap is always safe (guaranteed safe zone)

- **Game Features**:
  - Timer tracking your progress
  - Remaining mines counter
  - Haptic feedback for interactions
  - Game state persistence (resume where you left off)
  - Full-screen win/lose celebration modals

## Architecture

This project follows **SOLID principles** with **protocol composition**:

### Protocols
- `BoardGenerating` - Mine placement and adjacent count calculation
- `CellRevealing` - Cell reveal logic with flood fill
- `CellMarking` - Flag and question mark management
- `GameStateManaging` - Win/lose condition checking
- `GamePersisting` - Save/load game state
- `HapticProviding` - Haptic feedback abstraction
- `TimerProviding` - Timer functionality abstraction
- `RandomNumberGenerating` - Randomness abstraction for testing

### Services
- `BoardGenerator` - Implements mine placement with safe zone
- `CellRevealer` - Implements iterative flood fill reveal
- `CellMarker` - Implements flag/question mark toggling
- `GameStateManager` - Implements win/lose detection
- `GamePersistenceService` - JSON-based file persistence
- `HapticService` - UIKit haptic feedback
- `GameTimer` - Timer implementation
- `GameEngine` - Composes all game-related protocols

### ViewModel
- `GameViewModel` - `@Observable` state container with Swift 6 concurrency

### Views
- `ContentView` - Root view with navigation
- `DifficultySelectionView` - Difficulty picker
- `GameView` - Main game screen
- `BoardView` - Grid of cells with scrolling
- `CellView` - Individual cell with gestures
- `GameHeaderView` - Timer, mine counter, controls
- `GameOverModalView` - Full-screen celebration with confetti

## Requirements

- iOS 18.0+
- Xcode 16.2+
- Swift 6.0

## Testing

The project includes comprehensive unit tests with mock implementations of all protocols:

- `BoardGeneratorTests` - Mine placement and adjacent calculation
- `CellRevealerTests` - Reveal logic and flood fill
- `CellMarkerTests` - Flag and question mark toggling
- `GameStateManagerTests` - Win/lose detection
- `GameViewModelTests` - Integration tests with mocks
- `PositionTests` - Adjacent position calculation
- `BoardTests` - Board operations and queries
- `DifficultyTests` - Difficulty configuration

Run tests with `Cmd+U` in Xcode or:
```bash
xcodebuild test -scheme Swinemeeper -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Project Structure

```
Swinemeeper/
├── Models/
│   ├── Cell.swift
│   ├── CellState.swift
│   ├── Position.swift
│   ├── Board.swift
│   ├── GameState.swift
│   ├── GameStatus.swift
│   └── Difficulty.swift
├── Protocols/
│   ├── BoardGenerating.swift
│   ├── CellRevealing.swift
│   ├── CellMarking.swift
│   ├── GameStateManaging.swift
│   ├── GamePersisting.swift
│   ├── HapticProviding.swift
│   ├── TimerProviding.swift
│   └── RandomNumberGenerating.swift
├── Services/
│   ├── BoardGenerator.swift
│   ├── CellRevealer.swift
│   ├── CellMarker.swift
│   ├── GameStateManager.swift
│   ├── GameEngine.swift
│   ├── GamePersistenceService.swift
│   ├── HapticService.swift
│   └── GameTimer.swift
├── ViewModels/
│   └── GameViewModel.swift
├── Views/
│   ├── ContentView.swift
│   ├── DifficultySelectionView.swift
│   ├── GameView.swift
│   ├── BoardView.swift
│   ├── CellView.swift
│   ├── GameHeaderView.swift
│   └── GameOverModalView.swift
└── SwinemeperApp.swift

SwinemeperTests/
├── Mocks/
│   ├── MockRandomNumberGenerator.swift
│   ├── MockBoardGenerator.swift
│   ├── MockCellRevealer.swift
│   ├── MockCellMarker.swift
│   ├── MockGameStateManager.swift
│   ├── MockGamePersistence.swift
│   ├── MockHapticProvider.swift
│   ├── MockTimerProvider.swift
│   └── MockGameEngine.swift
├── BoardGeneratorTests.swift
├── CellRevealerTests.swift
├── CellMarkerTests.swift
├── GameStateManagerTests.swift
├── GameViewModelTests.swift
├── PositionTests.swift
├── BoardTests.swift
└── DifficultyTests.swift
```

## License

MIT License
