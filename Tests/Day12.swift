import Testing

@testable import AdventOfCode

struct Day12Tests {
    let testData = [
        (
            input: """
            AAAA
            BBCD
            BBCC
            EEEC

            """,
            result1: 140,
            result2: 80
        ),
        (
            input: """
            OOOOO
            OXOXO
            OOOOO
            OXOXO
            OOOOO

            """,
            result1: 772,
            result2: 436
        ),
        (
            input: """
            RRRRIICCFF
            RRRRIICCCF
            VVRRRCCFFF
            VVRCCCJFFF
            VVVVCJJCFE
            VVIVCCJJEE
            VVIIICJJEE
            MIIIIIJJEE
            MIIISIJEEE
            MMMISSJEEE

            """,
            result1: 1930,
            result2: 1206
        ),
        (
            input: """
            EEEEE
            EXXXX
            EEEEE
            EXXXX
            EEEEE

            """,
            result1: -1,
            result2: 236
        ),
        (
            input: """
            AAAAAA
            AAABBA
            AAABBA
            ABBAAA
            ABBAAA
            AAAAAA

            """,
            result1: -1,
            result2: 368
        ),
    ]

    @Test func testPart1() async throws {
        for testDataEl in testData {
            if testDataEl.result1 == -1 { continue }
            let challenge = Day12(data: testDataEl.input)
            await #expect(challenge.part1() == testDataEl.result1)
        }
    }

    @Test func testPart2() async throws {
        for testDataEl in testData {
            if testDataEl.result2 == -1 { continue }
            let challenge = Day12(data: testDataEl.input)
            await #expect(challenge.part2() == testDataEl.result2)
        }
    }
}
