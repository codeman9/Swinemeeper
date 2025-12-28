import SwiftUI

/// Main game view containing the board and controls
struct GameView: View {
    @Bindable var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                GameHeaderView(
                    remainingMines: viewModel.remainingMines,
                    formattedTime: viewModel.formattedTime,
                    isQuestionMarkModeEnabled: viewModel.isQuestionMarkModeEnabled,
                    onNewGame: { viewModel.newGame() },
                    onToggleQuestionMarkMode: { viewModel.toggleQuestionMarkMode() }
                )

                Spacer()

                BoardView(
                    board: viewModel.board,
                    onCellTap: { position in
                        viewModel.handleTap(at: position)
                    },
                    onCellLongPress: { position in
                        viewModel.handleLongPress(at: position)
                    }
                )

                Spacer()

                // Difficulty indicator
                Text(viewModel.difficulty.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)
            }
            .padding()
            .navigationTitle("Swinemeeper")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Menu") {
                        dismiss()
                    }
                }
            }
            .fullScreenCover(isPresented: .init(
                get: { viewModel.showGameOverModal },
                set: { _ in viewModel.dismissGameOverModal() }
            )) {
                GameOverModalView(
                    didWin: viewModel.status == .won,
                    time: viewModel.formattedTime,
                    difficulty: viewModel.difficulty,
                    onNewGame: {
                        viewModel.newGame()
                    },
                    onChangeDifficulty: {
                        viewModel.dismissGameOverModal()
                        dismiss()
                    }
                )
            }
        }
        .task {
            await viewModel.loadSavedGame()
        }
    }
}

#Preview {
    GameView(viewModel: GameViewModel(difficulty: .easy))
}
