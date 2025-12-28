import SwiftUI

/// View representing a single cell on the board
struct CellView: View {
    let cell: Cell
    let cellSize: CGFloat
    let onTap: () -> Void
    let onLongPress: () -> Void

    @State private var isPressed = false

    var body: some View {
        ZStack {
            cellBackground
            cellContent
        }
        .frame(width: cellSize, height: cellSize)
        .contentShape(Rectangle())
        .gesture(
            LongPressGesture(minimumDuration: 0.3)
                .onEnded { _ in
                    onLongPress()
                }
                .simultaneously(with: TapGesture()
                    .onEnded {
                        onTap()
                    }
                )
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }

    @ViewBuilder
    private var cellBackground: some View {
        if cell.isRevealed {
            if cell.hasMine {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.red.opacity(0.7))
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
            }
        } else {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.blue.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.blue.opacity(0.8), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
        }
    }

    @ViewBuilder
    private var cellContent: some View {
        if cell.isRevealed {
            if cell.hasMine {
                Image(systemName: "burst.fill")
                    .font(.system(size: cellSize * 0.5))
                    .foregroundStyle(.black)
            } else if cell.adjacentMines > 0 {
                Text("\(cell.adjacentMines)")
                    .font(.system(size: cellSize * 0.5, weight: .bold, design: .rounded))
                    .foregroundStyle(colorForNumber(cell.adjacentMines))
            }
        } else if cell.isFlagged {
            Image(systemName: "flag.fill")
                .font(.system(size: cellSize * 0.45))
                .foregroundStyle(.red)
        } else if cell.isQuestioned {
            Text("?")
                .font(.system(size: cellSize * 0.5, weight: .bold))
                .foregroundStyle(.yellow)
        }
    }

    private func colorForNumber(_ number: Int) -> Color {
        switch number {
        case 1: return .blue
        case 2: return .green
        case 3: return .red
        case 4: return .purple
        case 5: return .orange
        case 6: return .cyan
        case 7: return .black
        case 8: return .gray
        default: return .primary
        }
    }
}

#Preview {
    HStack(spacing: 4) {
        CellView(
            cell: Cell(row: 0, column: 0, hasMine: false, adjacentMines: 0, state: .hidden),
            cellSize: 40,
            onTap: {},
            onLongPress: {}
        )
        CellView(
            cell: Cell(row: 0, column: 1, hasMine: false, adjacentMines: 3, state: .revealed),
            cellSize: 40,
            onTap: {},
            onLongPress: {}
        )
        CellView(
            cell: Cell(row: 0, column: 2, hasMine: false, adjacentMines: 0, state: .flagged),
            cellSize: 40,
            onTap: {},
            onLongPress: {}
        )
        CellView(
            cell: Cell(row: 0, column: 3, hasMine: true, adjacentMines: 0, state: .revealed),
            cellSize: 40,
            onTap: {},
            onLongPress: {}
        )
    }
    .padding()
}
