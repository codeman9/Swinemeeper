import SwiftUI

/// View showing game status, timer, and controls
struct GameHeaderView: View {
    let remainingMines: Int
    let formattedTime: String
    let isQuestionMarkModeEnabled: Bool
    let onNewGame: () -> Void
    let onToggleQuestionMarkMode: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            // Mine counter
            HStack(spacing: 6) {
                Image(systemName: "burst.fill")
                    .foregroundStyle(.red)
                Text("\(remainingMines)")
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.secondarySystemBackground))
            )

            Spacer()

            // New game button
            Button(action: onNewGame) {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.orange)
            }

            Spacer()

            // Question mark mode toggle
            Button(action: onToggleQuestionMarkMode) {
                Image(systemName: isQuestionMarkModeEnabled ? "questionmark.circle.fill" : "questionmark.circle")
                    .font(.system(size: 28))
                    .foregroundStyle(isQuestionMarkModeEnabled ? .yellow : .gray)
            }

            // Timer
            HStack(spacing: 6) {
                Image(systemName: "clock.fill")
                    .foregroundStyle(.blue)
                Text(formattedTime)
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .padding(.horizontal)
    }
}

#Preview {
    VStack(spacing: 20) {
        GameHeaderView(
            remainingMines: 10,
            formattedTime: "02:34",
            isQuestionMarkModeEnabled: false,
            onNewGame: {},
            onToggleQuestionMarkMode: {}
        )

        GameHeaderView(
            remainingMines: 5,
            formattedTime: "10:00",
            isQuestionMarkModeEnabled: true,
            onNewGame: {},
            onToggleQuestionMarkMode: {}
        )
    }
    .padding()
}
