import Algorithms
import Foundation

private enum Field: String {
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

private typealias FieldMap = [Point: Field]

@MainActor private var pointsToVisit: Set<Point> = []
@MainActor private var pointsVisited: Set<Point> = []
@MainActor private var lowestTime: [Point: Int] = [:]
@MainActor private var map: FieldMap = [:]

@MainActor struct Day20: AdventDay {
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

    fileprivate func getMap() -> FieldMap {
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

    func checkFields() {
        while !pointsToVisit.isEmpty {
            let nextPoint = pointsToVisit.sorted(by: { lowestTime[$0] ?? Int.max < lowestTime[$1] ?? Int.max }).first!
            pointsToVisit.remove(nextPoint)
            visitField(atPoint: nextPoint)
        }
    }

    func visitField(atPoint currentPoint: Point) {
        for nextDirection in directions {
            let nextPoint = currentPoint + nextDirection
            let nextField = map[nextPoint]
            if nextField == nil || nextField == .wall { continue }

            guard let currentTime = lowestTime[currentPoint] else { continue }
            let nextTime = currentTime + 1

            let nextLowestTime = lowestTime[nextPoint] ?? Int.max
            if nextTime < nextLowestTime {
                lowestTime[nextPoint] = nextTime
                if !pointsVisited.contains(nextPoint) {
                    pointsToVisit.insert(nextPoint)
                }
            }
        }
    }

    func part1() -> Int {
        map = getMap()
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

        lowestTime[startPoint] = 0
        pointsToVisit.insert(startPoint)
        checkFields()
        let time = lowestTime[endPoint]
        print(time!)

        return -1
    }

    func part2() -> Any {
        return -1
    }
}
