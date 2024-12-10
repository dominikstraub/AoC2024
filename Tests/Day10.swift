import Testing

@testable import AdventOfCode

struct Day10Tests {
    let testData = [
        (
            input: """
            0123
            1234
            8765
            9876

            """,
            result1: 1,
            result2: -1
        ), (
            input: """
            ...0...
            ...1...
            ...2...
            6543456
            7.....7
            8.....8
            9.....9

            """,
            result1: 2,
            result2: -1
        ), (
            input: """
            ..90..9
            ...1.98
            ...2..7
            6543456
            765.987
            876....
            987....

            """,
            result1: 4,
            result2: -1
        ), (
            input: """
            10..9..
            2...8..
            3...7..
            4567654
            ...8..3
            ...9..2
            .....01

            """,
            result1: 3,
            result2: -1
        ), (
            input: """
            89010123
            78121874
            87430965
            96549874
            45678903
            32019012
            01329801
            10456732

            """,
            result1: 36,
            result2: -1
        ),
    ]

    @Test func testPart1() async throws {
        for testDataEl in testData {
            let challenge = Day10(data: testDataEl.input)
            #expect(challenge.part1() == testDataEl.result1)
        }
    }

    @Test func testPart2() async throws {
        for testDataEl in testData {
            let challenge = Day10(data: testDataEl.input)
            #expect(challenge.part1() == testDataEl.result2)
        }
    }
}
