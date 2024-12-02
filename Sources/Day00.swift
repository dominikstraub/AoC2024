import Algorithms

struct Day00: AdventDay {
    var data: String

    var entities: [[Int]] {
        data.split(separator: "\n\n").map {
            $0.split(separator: "\n").compactMap { Int($0) }
        }
    }

    func part1() -> Any {
        entities.first?.reduce(0, +) ?? 0
    }

    func part2() -> Any {
        entities.map { $0.max() ?? 0 }.reduce(0, +)
    }
}
