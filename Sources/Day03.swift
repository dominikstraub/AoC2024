import Algorithms

struct Day03: AdventDay {
    var data: String

    var entities: [[Int]] {
        data.split(separator: "\n").map {
            $0.split(separator: " ").compactMap { Int($0) }
        }
    }

    func part1() -> Int {
        return 0
    }

    func part2() -> Int {
        return 0
    }
}
