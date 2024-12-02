import Testing

@testable import AdventOfCode

struct Day00Tests {
    let testData = """
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

    """

    @Test func testPart1() async throws {
        let challenge = Day00(data: testData)
        #expect(String(describing: challenge.part1()) == "6000")
    }

    @Test func testPart2() async throws {
        let challenge = Day00(data: testData)
        #expect(String(describing: challenge.part2()) == "32000")
    }
}
