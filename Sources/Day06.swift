import Algorithms
import Foundation

enum MapField: String {
    case obstruction = "#"
    case newObstruction = "0"
    case guardUp = "^"
    case guardRight = ">"
    case guardDown = "v"
    case guardLeft = "<"
    case empty = "."
    case visitedUp = "@"
    case visitedRight = "$"
    case visitedDown = "&"
    case visitedLeft = "*"
}

extension MapField: CustomStringConvertible {
    var description: String {
        rawValue
    }
}

struct Map {
    var data: [[MapField]]
    var guardPosition: (Int, Int)?
    var guardLoop = false
    var previousGuardPositionValue: MapField?
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
            if let tmp = data[safe: nextGuardPosition.1]?[safe: nextGuardPosition.0], tmp == .obstruction || tmp == .newObstruction {
                nextGuardPosition = guardPosition
                nextGuardDirection = .guardRight
            }
            if [.visitedUp, .visitedRight, .visitedDown, .visitedLeft].contains(previousGuardPositionValue) {
                data[guardPosition.1][guardPosition.0] = previousGuardPositionValue!
            } else {
                data[guardPosition.1][guardPosition.0] = .visitedUp
            }
        case .guardRight:
            nextGuardPosition.0 += 1
            if let tmp = data[safe: nextGuardPosition.1]?[safe: nextGuardPosition.0], tmp == .obstruction || tmp == .newObstruction {
                nextGuardPosition = guardPosition
                nextGuardDirection = .guardDown
            }
            if [.visitedUp, .visitedRight, .visitedDown, .visitedLeft].contains(previousGuardPositionValue) {
                data[guardPosition.1][guardPosition.0] = previousGuardPositionValue!
            } else {
                data[guardPosition.1][guardPosition.0] = .visitedRight
            }
        case .guardDown:
            nextGuardPosition.1 += 1
            if let tmp = data[safe: nextGuardPosition.1]?[safe: nextGuardPosition.0], tmp == .obstruction || tmp == .newObstruction {
                nextGuardPosition = guardPosition
                nextGuardDirection = .guardLeft
            }
            if [.visitedUp, .visitedRight, .visitedDown, .visitedLeft].contains(previousGuardPositionValue) {
                data[guardPosition.1][guardPosition.0] = previousGuardPositionValue!
            } else {
                data[guardPosition.1][guardPosition.0] = .visitedDown
            }
        case .guardLeft:
            nextGuardPosition.0 -= 1
            if let tmp = data[safe: nextGuardPosition.1]?[safe: nextGuardPosition.0], tmp == .obstruction || tmp == .newObstruction {
                nextGuardPosition = guardPosition
                nextGuardDirection = .guardUp
            }
            if [.visitedUp, .visitedRight, .visitedDown, .visitedLeft].contains(previousGuardPositionValue) {
                data[guardPosition.1][guardPosition.0] = previousGuardPositionValue!
            } else {
                data[guardPosition.1][guardPosition.0] = .visitedLeft
            }
        case .newObstruction:
            break
        case .obstruction:
            break
        case .empty:
            break
        case .visitedUp:
            break
        case .visitedRight:
            break
        case .visitedDown:
            break
        case .visitedLeft:
            break
        }
        if data[safe: nextGuardPosition.1]?[safe: nextGuardPosition.0] == nil {
            self.guardPosition = nil
        } else {
            switch nextGuardDirection {
            case .guardUp:
                if data[nextGuardPosition.1][nextGuardPosition.0] == .visitedUp {
                    guardLoop = true
                }
            case .guardRight:
                if data[nextGuardPosition.1][nextGuardPosition.0] == .visitedRight {
                    guardLoop = true
                }
            case .guardDown:
                if data[nextGuardPosition.1][nextGuardPosition.0] == .visitedDown {
                    guardLoop = true
                }
            case .guardLeft:
                if data[nextGuardPosition.1][nextGuardPosition.0] == .visitedLeft {
                    guardLoop = true
                }
            default:
                break
            }
            previousGuardPositionValue = data[nextGuardPosition.1][nextGuardPosition.0]
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
        // print(map)
        while map.guardPosition != nil {
            map.nextRound()
            // print(map)
        }
        return map.data.flatMap { $0 }.filter { [.visitedUp, .visitedRight, .visitedDown, .visitedLeft].contains($0) }.count
    }

    func part2() async -> Int {
        var firstMap = inputMap
        while firstMap.guardPosition != nil {
            firstMap.nextRound()
        }

        var count = 0

        await withTaskGroup(of: Bool.self) { group in
            for (y, row) in firstMap.data.enumerated() {
                for (x, value) in row.enumerated() {
                    group.addTask {
                        guard [.visitedUp, .visitedRight, .visitedDown, .visitedLeft].contains(value),
                              let guardPosition = inputMap.guardPosition,
                              guardPosition != (x, y) else { return false }

                        var map = inputMap
                        map.data[y][x] = .newObstruction

                        while map.guardPosition != nil && !map.guardLoop {
                            map.nextRound()
                        }

                        return map.guardLoop
                    }
                }
            }

            for await result in group where result {
                count += 1
            }
        }

        return count
    }
}
