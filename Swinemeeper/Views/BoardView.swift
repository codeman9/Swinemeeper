import SwiftUI

/// View representing the game board
struct BoardView: View {
    let board: Board
    let onCellTap: (Position) -> Void
    let onCellLongPress: (Position) -> Void

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var cellSize: CGFloat {
        // Adjust cell size based on board dimensions and device
        let baseSizeForEasy: CGFloat = 36
        let baseSizeForMedium: CGFloat = 28
        let baseSizeForHard: CGFloat = 22

        if board.columns <= 9 {
            return baseSizeForEasy
        } else if board.columns <= 16 {
            return baseSizeForMedium
        } else {
            return baseSizeForHard
        }
    }

    private var spacing: CGFloat {
        cellSize > 30 ? 3 : 2
    }

    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            VStack(spacing: spacing) {
                ForEach(0..<board.rows, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(0..<board.columns, id: \.self) { column in
                            let cell = board[row, column]
                            CellView(
                                cell: cell,
                                cellSize: cellSize,
                                onTap: { onCellTap(Position(row: row, column: column)) },
                                onLongPress: { onCellLongPress(Position(row: row, column: column)) }
                            )
                        }
                    }
                }
            }
            .padding(8)
        }
        .background(Color(.systemBackground).opacity(0.95))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    BoardView(
        board: Board(difficulty: .easy),
        onCellTap: { _ in },
        onCellLongPress: { _ in }
    )
    .padding()
}
