import Testing
@testable import Swinemeeper

@Suite("Difficulty Tests")
struct DifficultyTests {

    @Test("Easy difficulty has correct values")
    func easyDifficultyValues() {
        let easy = Difficulty.easy

        #expect(easy.rows == 9)
        #expect(easy.columns == 9)
        #expect(easy.mineCount == 10)
        #expect(easy.displayName == "Easy")
    }

    @Test("Medium difficulty has correct values")
    func mediumDifficultyValues() {
        let medium = Difficulty.medium

        #expect(medium.rows == 16)
        #expect(medium.columns == 16)
        #expect(medium.mineCount == 40)
        #expect(medium.displayName == "Medium")
    }

    @Test("Hard difficulty has correct values")
    func hardDifficultyValues() {
        let hard = Difficulty.hard

        #expect(hard.rows == 16)
        #expect(hard.columns == 30)
        #expect(hard.mineCount == 99)
        #expect(hard.displayName == "Hard")
    }

    @Test("All cases returns all difficulties")
    func allCasesReturnsAll() {
        #expect(Difficulty.allCases.count == 3)
        #expect(Difficulty.allCases.contains(.easy))
        #expect(Difficulty.allCases.contains(.medium))
        #expect(Difficulty.allCases.contains(.hard))
    }

    @Test("Description format is correct")
    func descriptionFormat() {
        #expect(Difficulty.easy.description == "9×9 • 10 mines")
        #expect(Difficulty.medium.description == "16×16 • 40 mines")
        #expect(Difficulty.hard.description == "16×30 • 99 mines")
    }
}
