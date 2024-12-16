import Algorithms
import Foundation

struct Day16: AdventDay {
    var data: String

    var entities: [[Int]] {
        data.split(separator: "\n\n").map {
            $0.split(separator: "\n").compactMap { Int($0) }
        }
    }

    func part1() -> Int {
        return -1
    }

    func part2() -> Any {
        return -1
    }
}
