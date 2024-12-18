import Testing

@testable import AdventOfCode

struct Day18Tests {
    let testData = [
        (
            input: """
            5,4
            4,2
            4,5
            3,0
            2,1
            6,3
            2,4
            1,5
            0,6
            3,3
            2,6
            5,1
            1,2
            5,5
            2,5
            6,5
            1,4
            0,4
            6,4
            1,1
            6,1
            1,0
            0,5
            1,6
            2,0

            """,
            result1: "22",
            result2: "(6, 1)"
        ),
    ]

    @Test func testPart1() async throws {
        for testDataEl in testData {
            if testDataEl.result1 == "-1" { continue }
            let challenge = Day18(data: testDataEl.input)
            await #expect(challenge.part1() == testDataEl.result1)
        }
    }

    @Test func testPart2() async throws {
        for testDataEl in testData {
            if testDataEl.result2 == "(0, 0)" { continue }
            let challenge = Day18(data: testDataEl.input)
            await #expect(challenge.part2() == testDataEl.result2)
        }
    }
}
