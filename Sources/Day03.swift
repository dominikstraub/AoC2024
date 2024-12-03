import Algorithms
import Foundation

enum Instruction {
    case mul(Int, Int)
    case `do`
    case dont
    case error
}

struct Day03: AdventDay {
    var data: String

    var entities1: [(Int, Int)] {
        let pattern = "mul\\(([0-9]+),([0-9]+)\\)"
        let regex = try? NSRegularExpression(pattern: pattern)
        guard let matches = regex?.matches(in: data, options: [], range: NSRange(location: 0, length: data.utf8.count)) else { return [] }
        return matches.compactMap { match in
            (Range(match.range(at: 1), in: data).map { Int(data[$0]) }, Range(match.range(at: 2), in: data).map { Int(data[$0]) }) as? (Int, Int)
        }
    }

    var entities2: [Instruction] {
        let pattern = "(mul\\(([0-9]+),([0-9]+)\\))|(do\\(\\))|(don't\\(\\))"
        let regex = try? NSRegularExpression(pattern: pattern)
        guard let matches = regex?.matches(in: data, options: [], range: NSRange(location: 0, length: data.utf8.count)) else { return [] }
        return matches.compactMap { match in
            for index in 1 ..< match.numberOfRanges {
                if let _ = Range(match.range(at: index), in: data) {
                    switch index {
                    case 1:
                        return .mul(Range(match.range(at: 2), in: data).map { Int(data[$0]) }!!, Range(match.range(at: 3), in: data).map { Int(data[$0]) }!!)
                    case 4:
                        return .do
                    case 5:
                        return .dont
                    default:
                        return .error
                    }
                }
            }
            return .error
        }
    }

    func part1() -> Int {
        return (entities1.reduce(0) { $0 + $1.0 * $1.1 })
    }

    func part2() -> Int {
        var mulEnabled = true
        var value = 0
        for instruction in entities2 {
            switch instruction {
            case let .mul(op1, op2):
                if mulEnabled {
                    value += op1 * op2
                }
            case .do:
                mulEnabled = true
            case .dont:
                mulEnabled = false
            case .error:
                break
            }
        }
        return value
    }
}
