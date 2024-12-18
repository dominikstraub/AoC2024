import Testing

@testable import AdventOfCode

struct Day13Tests {
    let testData: [(input: String, result1: Int, result2: Int)] = [
        (
            input: """
            1000
            2000
            3000

            4000

            5000
            6000

            7000
            8000
            9000

            10000

            """,
            result1: -1,
            result2: -1
        ),
    ]

    @Test func testPart1() async throws {
        for testDataEl in testData {
            if testDataEl.result1 == -1 { continue }
            let challenge = Day13(data: testDataEl.input)
            #expect(challenge.part1() == testDataEl.result1)
        }
    }

//    @Test func testPart2() async throws {
//        for testDataEl in testData {
//            if testDataEl.result2 == -1 { continue }
//            let challenge = Day13(data: testDataEl.input)
//            #expect(challenge.part2() == testDataEl.result2)
//        }
//    }
}
