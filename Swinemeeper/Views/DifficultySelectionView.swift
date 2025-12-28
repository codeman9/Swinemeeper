import SwiftUI

/// View for selecting game difficulty
struct DifficultySelectionView: View {
    let onSelect: (Difficulty) -> Void

    var body: some View {
        VStack(spacing: 24) {
            // Title
            VStack(spacing: 8) {
                Image(systemName: "flag.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.red)

                Text("Swinemeeper")
                    .font(.system(size: 40, weight: .bold, design: .rounded))

                Text("Select Difficulty")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 40)

            Spacer()

            // Difficulty buttons
            VStack(spacing: 16) {
                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                    DifficultyButton(difficulty: difficulty) {
                        onSelect(difficulty)
                    }
                }
            }
            .padding(.horizontal, 32)

            Spacer()

            // Instructions
            VStack(spacing: 8) {
                Text("How to Play")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 4) {
                    Label("Tap to reveal", systemImage: "hand.tap.fill")
                    Label("Long press to flag", systemImage: "hand.tap.fill")
                    Label("Use ? button for question marks", systemImage: "questionmark.circle")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding(.bottom, 32)
        }
    }
}

struct DifficultyButton: View {
    let difficulty: Difficulty
    let action: () -> Void

    private var buttonColor: Color {
        switch difficulty {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }

    private var iconName: String {
        switch difficulty {
        case .easy: return "face.smiling"
        case .medium: return "face.dashed"
        case .hard: return "flame"
        }
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .font(.title2)

                VStack(alignment: .leading, spacing: 2) {
                    Text(difficulty.displayName)
                        .font(.title2.weight(.semibold))
                    Text(difficulty.description)
                        .font(.caption)
                        .opacity(0.8)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.title3)
                    .opacity(0.6)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(buttonColor.gradient)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: buttonColor.opacity(0.4), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    DifficultySelectionView { difficulty in
        print("Selected: \(difficulty)")
    }
}
