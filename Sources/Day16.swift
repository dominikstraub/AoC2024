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

// @MainActor var visitedFields: Set<Point> = []
@MainActor var lowestPoints: [Point: Int] = [:]

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

    func visitField(_ point: Point, direction: Point, points: Int, map: FieldMap) {
        // visitedFields.insert(point)
        if lowestPoints[point] ?? Int.max > points {
            lowestPoints[point] = points
        }
        for dir in directions {
            let nextPoint = point + dir
            // if visitedFields.contains(nextPoint) { continue }
            let nextField = map[nextPoint]
            if nextField == nil || nextField == .wall { continue }
            var nextPoints = points + 1
            if dir != direction {
                nextPoints += 1000
                if dir * -1 == direction {
                    nextPoints += 1000
                }
            }
            visitField(nextPoint, direction: dir, points: nextPoints, map: map)
        }
    }

    func part1() -> Int {
        // visitedFields = []
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
        visitField(startPoint, direction: Point(1, 0), points: 0, map: map)
        printMap(lowestPoints, emptyValue: 0)
        return lowestPoints[endPoint] ?? -1
    }

    func part2() -> Any {
        return -1
    }
}
