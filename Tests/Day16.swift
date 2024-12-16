import Testing

@testable import AdventOfCode

struct Day16Tests {
    let testData: [(input: String, result1: Int, result2: Int)] = [
        (
            input: """
            ###############
            #.......#....E#
            #.#.###.#.###.#
            #.....#.#...#.#
            #.###.#####.#.#
            #.#.#.......#.#
            #.#.#####.###.#
            #...........#.#
            ###.#.#####.#.#
            #...#.....#.#.#
            #.#.#.###.#.#.#
            #.....#...#.#.#
            #.###.#.#.#.#.#
            #S..#.....#...#
            ###############

            """,
            result1: 7036,
            result2: -1
        ),
        // (
        //     input: """
        //     #################
        //     #...#...#...#..E#
        //     #.#.#.#.#.#.#.#.#
        //     #.#.#.#...#...#.#
        //     #.#.#.#.###.#.#.#
        //     #...#.#.#.....#.#
        //     #.#.#.#.#.#####.#
        //     #.#...#.#.#.....#
        //     #.#.#####.#.###.#
        //     #.#.#.......#...#
        //     #.#.###.#####.###
        //     #.#.#...#.....#.#
        //     #.#.#.#####.###.#
        //     #.#.#.........#.#
        //     #.#.#.#########.#
        //     #S#.............#
        //     #################

        //     """,
        //     result1: 11048,
        //     result2: -1
        // ),
    ]

    @Test func testPart1() async throws {
        for testDataEl in testData {
            if testDataEl.result1 == -1 { continue }
            let challenge = Day16(data: testDataEl.input)
            await #expect(challenge.part1() == testDataEl.result1)
        }
    }

//    @Test func testPart2() async throws {
//        for testDataEl in testData {
//            if testDataEl.result2 == -1 { continue }
//            let challenge = Day16(data: testDataEl.input)
//            await #expect(challenge.part2() == testDataEl.result2)
//        }
//    }
}
