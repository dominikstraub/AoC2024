import Algorithms
import Foundation

enum MapField: String {
    case obstruction = "#"
    case guardUp = "^"
    case guardRight = ">"
    case guardDown = "v"
    case guardLeft = "<"
    case empty = "."
    case visited = "%"
}

extension MapField: CustomStringConvertible {
    var description: String {
        rawValue
    }
}

struct Map {
    var data: [[MapField]]
    var guardPosition: (Int, Int)?
}

extension Map: CustomStringConvertible {
    var description: String {
        (data.map {
            $0.map(\.description).joined()
        }).joined(separator: "\n")
    }
}

extension Map {
    mutating func nextRound() {
        guard let guardPosition else { return }
        var nextGuardPosition = guardPosition
        guard let guardDirection = data[safe: guardPosition.1]?[safe: guardPosition.0] else { return }
        var nextGuardDirection = guardDirection
        switch guardDirection {
        case .guardUp:
            nextGuardPosition.1 -= 1
            if let tmp = data[safe: nextGuardPosition.1]?[safe: nextGuardPosition.0], tmp == .obstruction {
                nextGuardPosition = guardPosition
                nextGuardDirection = .guardRight
            }
        case .guardRight:
            nextGuardPosition.0 += 1
            if let tmp = data[safe: nextGuardPosition.1]?[safe: nextGuardPosition.0], tmp == .obstruction {
                nextGuardPosition = guardPosition
                nextGuardDirection = .guardDown
            }
        case .guardDown:
            nextGuardPosition.1 += 1
            if let tmp = data[safe: nextGuardPosition.1]?[safe: nextGuardPosition.0], tmp == .obstruction {
                nextGuardPosition = guardPosition
                nextGuardDirection = .guardLeft
            }
        case .guardLeft:
            nextGuardPosition.0 -= 1
            if let tmp = data[safe: nextGuardPosition.1]?[safe: nextGuardPosition.0], tmp == .obstruction {
                nextGuardPosition = guardPosition
                nextGuardDirection = .guardUp
            }
        case .obstruction:
            break
        case .empty:
            break
        case .visited:
            break
        }
        data[guardPosition.1][guardPosition.0] = .visited
        if data[safe: nextGuardPosition.1]?[safe: nextGuardPosition.0] == nil {
            self.guardPosition = nil
        } else {
            data[nextGuardPosition.1][nextGuardPosition.0] = nextGuardDirection
            self.guardPosition = nextGuardPosition
        }
    }
}

struct Day06: AdventDay {
    var data: String

    var inputMap: Map {
        var guardPosition: (Int, Int)?
        let mapData = data.split(separator: "\n").enumerated().compactMap { y, row in
            row.enumerated().compactMap { x, value in
                var val = MapField.empty
                switch String(value) {
                case MapField.obstruction.description:
                    val = .obstruction
                case MapField.empty.description:
                    val = .empty
                case MapField.guardUp.description:
                    val = .guardUp
                    guardPosition = (x, y)
                case MapField.guardRight.description:
                    val = .guardRight
                    guardPosition = (x, y)
                case MapField.guardDown.description:
                    val = .guardDown
                    guardPosition = (x, y)
                case MapField.guardLeft.description:
                    val = .guardLeft
                    guardPosition = (x, y)
                default:
                    val = .empty
                }
                return val
            }
        }
        return Map(data: mapData, guardPosition: guardPosition)
    }

    func part1() -> Int {
        var map = inputMap
        print(map)
        while map.guardPosition != nil {
            map.nextRound()
            print(map)
        }
        return map.data.flatMap { $0 }.filter { $0 == .visited }.count
    }

    func part2() -> Any {
        return 0
    }
}
