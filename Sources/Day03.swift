import Algorithms
import Foundation

struct Day03: AdventDay {
    var data: String

    var entities: [(Int, Int)] {
        let pattern = "mul\\(([0-9]+),([0-9]+)\\)"
        let regex = try? NSRegularExpression(pattern: pattern)
        guard let matches = regex?.matches(in: data, options: [], range: NSRange(location: 0, length: data.utf8.count)) else { return [] }
        return matches.compactMap { match in
            (Range(match.range(at: 1), in: data).map { Int(data[$0]) }, Range(match.range(at: 2), in: data).map { Int(data[$0]) }) as? (Int, Int)
        }
    }

    func part1() -> Int {
        return (entities.reduce(0) { $0 + $1.0 * $1.1 })
    }

    func part2() -> Int {
        return 0
    }
}
