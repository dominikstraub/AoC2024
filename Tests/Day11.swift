import Testing

@testable import AdventOfCode

struct Day11Tests {
    let testData = [
        (
            input: """
            125 17

            """,
            result1: 55312,
            result2: -1
        ),
    ]

    @Test func testPart1() async throws {
        for testDataEl in testData {
            let challenge = Day11(data: testDataEl.input)
            #expect(challenge.part1() == testDataEl.result1)
        }
    }

//    @Test func testPart2() async throws {
//        for testDataEl in testData {
//            let challenge = Day11(data: testDataEl.input)
//            #expect(testDataEl.result2 == nil || challenge.part2() == testDataEl.result2)
//        }
//    }
}
