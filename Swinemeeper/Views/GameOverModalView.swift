import SwiftUI

/// Full-screen modal shown when the game ends
struct GameOverModalView: View {
    let didWin: Bool
    let time: String
    let difficulty: Difficulty
    let onNewGame: () -> Void
    let onChangeDifficulty: () -> Void

    @State private var animateConfetti = false
    @State private var showContent = false

    var body: some View {
        ZStack {
            // Background
            (didWin ? Color.green.opacity(0.9) : Color.red.opacity(0.9))
                .ignoresSafeArea()

            // Confetti effect for win
            if didWin && animateConfetti {
                ConfettiView()
            }

            // Content
            VStack(spacing: 32) {
                Spacer()

                // Icon
                Image(systemName: didWin ? "trophy.fill" : "burst.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(didWin ? .yellow : .black)
                    .scaleEffect(showContent ? 1 : 0.5)
                    .opacity(showContent ? 1 : 0)

                // Title
                Text(didWin ? "You Won!" : "Game Over")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .scaleEffect(showContent ? 1 : 0.8)
                    .opacity(showContent ? 1 : 0)

                // Stats
                VStack(spacing: 12) {
                    if didWin {
                        HStack {
                            Image(systemName: "clock.fill")
                            Text("Time: \(time)")
                        }
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                    }

                    HStack {
                        Image(systemName: "chart.bar.fill")
                        Text("Difficulty: \(difficulty.displayName)")
                    }
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.9))
                }
                .opacity(showContent ? 1 : 0)

                Spacer()

                // Buttons
                VStack(spacing: 16) {
                    Button(action: onNewGame) {
                        Label("Play Again", systemImage: "arrow.clockwise")
                            .font(.title2.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white)
                            .foregroundStyle(didWin ? .green : .red)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    Button(action: onChangeDifficulty) {
                        Label("Change Difficulty", systemImage: "slider.horizontal.3")
                            .font(.title3.weight(.medium))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white.opacity(0.2))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding(.horizontal, 32)
                .opacity(showContent ? 1 : 0)

                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showContent = true
            }
            if didWin {
                animateConfetti = true
            }
        }
    }
}

/// Simple confetti effect view
struct ConfettiView: View {
    @State private var confettiPieces: [ConfettiPiece] = []

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(confettiPieces) { piece in
                    ConfettiPieceView(piece: piece)
                }
            }
            .onAppear {
                createConfetti(in: geometry.size)
            }
        }
    }

    private func createConfetti(in size: CGSize) {
        confettiPieces = (0..<50).map { _ in
            ConfettiPiece(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: -100...0),
                color: [Color.yellow, .orange, .pink, .purple, .cyan, .white].randomElement()!,
                size: CGFloat.random(in: 8...16),
                rotation: Double.random(in: 0...360),
                delay: Double.random(in: 0...0.5)
            )
        }
    }
}

struct ConfettiPiece: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let color: Color
    let size: CGFloat
    let rotation: Double
    let delay: Double
}

struct ConfettiPieceView: View {
    let piece: ConfettiPiece

    @State private var offsetY: CGFloat = 0
    @State private var currentRotation: Double = 0
    @State private var opacity: Double = 1

    var body: some View {
        Rectangle()
            .fill(piece.color)
            .frame(width: piece.size, height: piece.size * 0.6)
            .rotationEffect(.degrees(currentRotation))
            .position(x: piece.x, y: piece.y + offsetY)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 3).delay(piece.delay)) {
                    offsetY = UIScreen.main.bounds.height + 200
                    currentRotation = piece.rotation + 720
                }
                withAnimation(.easeIn(duration: 2.5).delay(piece.delay + 0.5)) {
                    opacity = 0
                }
            }
    }
}

#Preview("Win") {
    GameOverModalView(
        didWin: true,
        time: "02:34",
        difficulty: .medium,
        onNewGame: {},
        onChangeDifficulty: {}
    )
}

#Preview("Lose") {
    GameOverModalView(
        didWin: false,
        time: "01:15",
        difficulty: .easy,
        onNewGame: {},
        onChangeDifficulty: {}
    )
}
