import Testing

@testable import AdventOfCode

struct Day19Tests {
    let testData = [
        (
            input: """
            r, wr, b, g, bwu, rb, gb, br

            brwrr
            bggr
            gbbr
            rrbgbr
            ubwu
            bwurrg
            brgr
            bbrgwb

            """,
            result1: 6,
            result2: 16
        ),
    ]

    @Test func testPart1() async throws {
        for testDataEl in testData {
            if testDataEl.result1 == -1 { continue }
            let challenge = Day19(data: testDataEl.input)
            await #expect(challenge.part1() == testDataEl.result1)
        }
    }

    @Test func testPart2() async throws {
        for testDataEl in testData {
            if testDataEl.result2 == -1 { continue }
            let challenge = Day19(data: testDataEl.input)
            await #expect(challenge.part2() == testDataEl.result2)
        }
    }
}
