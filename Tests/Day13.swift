import Testing

@testable import AdventOfCode

struct Day13Tests {
    let testData: [(input: String, result1: Int, result2: Int)] = [
        (
            input: """
            Button A: X+94, Y+34
            Button B: X+22, Y+67
            Prize: X=8400, Y=5400

            Button A: X+26, Y+66
            Button B: X+67, Y+21
            Prize: X=12748, Y=12176

            Button A: X+17, Y+86
            Button B: X+84, Y+37
            Prize: X=7870, Y=6450

            Button A: X+69, Y+23
            Button B: X+27, Y+71
            Prize: X=18641, Y=10279

            """,
            result1: 480,
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
