import Testing

@testable import AdventOfCode

struct Day20Tests {
    let testData = [
        (
            input: """
            ###############
            #...#...#.....#
            #.#.#.#.#.###.#
            #S#...#.#.#...#
            #######.#.#.###
            #######.#.#...#
            #######.#.###.#
            ###..E#...#...#
            ###.#######.###
            #...###...#...#
            #.#####.#.###.#
            #.#...#.#.#...#
            #.#.#.#.#.#.###
            #...#...#...###
            ###############

            """,
            result1: 11,
            result2: -1
        ),
    ]

    @Test func testPart1() async throws {
        for testDataEl in testData {
            if testDataEl.result1 == -1 { continue }
            let challenge = Day20(data: testDataEl.input)
            await #expect(challenge.part1() == testDataEl.result1)
        }
    }

//    @Test func testPart2() async throws {
//        for testDataEl in testData {
//            if testDataEl.result2 == -1 { continue }
//            let challenge = Day20(data: testDataEl.input)
//             #expect(challenge.part2() == testDataEl.result2)
//        }
//    }
}
