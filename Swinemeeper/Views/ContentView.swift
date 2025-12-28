import SwiftUI

/// Root view of the application
struct ContentView: View {
    @State private var selectedDifficulty: Difficulty?
    @State private var gameViewModel: GameViewModel?

    var body: some View {
        if let difficulty = selectedDifficulty, let viewModel = gameViewModel {
            GameView(viewModel: viewModel)
                .transition(.move(edge: .trailing))
                .onDisappear {
                    // When game view dismisses, reset selection
                    selectedDifficulty = nil
                    gameViewModel = nil
                }
        } else {
            DifficultySelectionView { difficulty in
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    selectedDifficulty = difficulty
                    gameViewModel = GameViewModel(difficulty: difficulty)
                }
            }
            .transition(.move(edge: .leading))
        }
    }
}

#Preview {
    ContentView()
}
