import Testing

@testable import AdventOfCode

struct Day08Tests {
    let testResult1 = 2
    let testData1 = """
    ..........
    ..........
    ..........
    ....a.....
    ..........
    .....a....
    ..........
    ..........
    ..........
    ..........

    """
    let testResult2 = 4
    let testData2 = """
    ..........
    ..........
    ..........
    ....a.....
    ........a.
    .....a....
    ..........
    ..........
    ..........
    ..........

    """
    let testResult3 = 4
    let testData3 = """
    ..........
    ..........
    ..........
    ....a.....
    ........a.
    .....a....
    ..........
    ......A...
    ..........
    ..........

    """
    let testResult4 = 14
    let testData4 = """
    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............

    """

    @Test func testPart1Input1() async throws {
        let challenge = Day08(data: testData1)
        #expect(challenge.part1() == testResult1)
    }

    @Test func testPart1Input2() async throws {
        let challenge = Day08(data: testData2)
        #expect(challenge.part1() == testResult2)
    }

    @Test func testPart1Input3() async throws {
        let challenge = Day08(data: testData3)
        #expect(challenge.part1() == testResult3)
    }

    @Test func testPart1Input4() async throws {
        let challenge = Day08(data: testData4)
        #expect(challenge.part1() == testResult4)
    }

    @Test func testPart2() async throws {
        let challenge = Day08(data: testData4)
        #expect(String(describing: challenge.part2()) == "0")
    }
}
