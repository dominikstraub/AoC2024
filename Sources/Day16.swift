import Algorithms
import Foundation

enum Field: String {
    case wall = "#"
    case empty = "."
    case start = "S"
    case end = "E"
}

extension Field: CustomStringConvertible {
    var description: String {
        rawValue
    }
}

typealias FieldMap = [Point: Field]

@MainActor var pointsToVisit: Set<[Point]> = []
@MainActor var lowestPoints: [[Point]: Int] = [:]

@MainActor struct Day16: AdventDay {
    nonisolated init(data: String) {
        self.data = data
    }

    var data: String

    let directions: Set<Point> = [
        Point(0, -1),
        Point(1, 0),
        Point(0, 1),
        Point(-1, 0),
    ]

    func getMap() -> FieldMap {
        var result: FieldMap = [:]
        for (y, row) in data.split(separator: "\n").enumerated() {
            for (x, value) in row.enumerated() {
                switch String(value) {
                case Field.wall.rawValue:
                    result[Point(x, y)] = .wall
                case Field.empty.rawValue:
                    result[Point(x, y)] = .empty
                case Field.start.rawValue:
                    result[Point(x, y)] = .start
                case Field.end.rawValue:
                    result[Point(x, y)] = .end
                default:
                    result[Point(x, y)] = .empty
                }
            }
        }
        return result
    }

    func checkFields(map: FieldMap) {
        while !pointsToVisit.isEmpty {
            let nextValues = pointsToVisit.removeFirst()
            let nextPoint = nextValues[0]
            let nextDir = nextValues[1]
            let currentDir = nextValues[2]
            guard let currentPoints = lowestPoints[nextValues] else {
                continue
            }

            var nextPoints = currentPoints + 1
            if nextDir != currentDir {
                nextPoints += 1000
                if nextDir * -1 == currentDir {
                    nextPoints += 1000
                }
            }
            if lowestPoints[[nextPoint, nextDir, currentDir]] ?? Int.max > nextPoints {
                lowestPoints[[nextPoint, nextDir, currentDir]] = nextPoints
            }
            visitField(nextPoint, direction: nextDir, map: map)
        }
    }

    func visitField(_ point: Point, direction: Point, map: FieldMap) {
        for dir in directions {
            let nextPoint = point + dir
            let nextField = map[nextPoint]
            if nextField == nil || nextField == .wall { continue }
            pointsToVisit.insert([nextPoint, dir, direction])
        }
    }

    func part1() -> Int {
        pointsToVisit = []
        lowestPoints = [:]
        let map = getMap()
        printMap(map, emptyValue: .empty)
        var startPoint: Point?
        var endPoint: Point?
        for (point, field) in map {
            if field == .start {
                startPoint = point
            }
            if field == .end {
                endPoint = point
            }
        }
        guard let startPoint else { return -1 }
        guard let endPoint else { return -1 }
        // visitField(startPoint, direction: Point(1, 0), points: 0, map: map)
        pointsToVisit.insert([startPoint, Point(1, 0), Point(1, 0)])
        lowestPoints[[startPoint, Point(1, 0), Point(1, 0)]] = 0
        checkFields(map: map)
        // printMap(lowestPoints, emptyValue: 0)
        return directions.map {
            lowestPoints[[endPoint, $0]] ?? Int.max
        }.min() ?? -1
    }

    func part2() -> Any {
        return -1
    }
}
