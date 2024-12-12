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
            result2: -1
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
            result2: -1
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
            result2: -1
        ),
    ]

    @Test func testPart1() async throws {
        for testDataEl in testData {
            let challenge = Day12(data: testDataEl.input)
            await #expect(challenge.part1() == testDataEl.result1)
        }
    }

    // @Test func testPart2() async throws {
    //     for testDataEl in testData {
    //         let challenge = Day12(data: testDataEl.input)
    //         #expect(testDataEl.result2 == nil || challenge.part2() == testDataEl.result2)
    //     }
    // }
}
