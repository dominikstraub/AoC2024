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

@MainActor private var pointsToVisit: Set<[Point]> = []
@MainActor private var lowestScore: [[Point]: (Int, Set<Point>)] = [:]
@MainActor private var map: FieldMap = [:]

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
            let nextValues = pointsToVisit.removeFirst()
            let nextPoint = nextValues[0]
            visitField(atPoint: nextPoint)
        }
    }

    func visitField(atPoint currentPoint: Point) {
        // printMap2(lowestScore, emptyValue: "#")
        for currentDirection in directions {
            for nextDirection in directions {
                let nextPoint = currentPoint + nextDirection
                let nextField = map[nextPoint]
                if nextField == nil || nextField == .wall { continue }

                guard let currentValue = lowestScore[[currentPoint, currentDirection]] else {
                    continue
                }
                let currentScore = currentValue.0
                var nextScore = currentScore + 1
                if nextDirection != currentDirection {
                    nextScore += 1000
                    if nextDirection * -1 == currentDirection {
                        nextScore += 1000
                    }
                }

                let currentBestPoints = currentValue.1
                var nextBestPoints = currentBestPoints
                nextBestPoints.insert(nextPoint)

                let nextLowestValues = lowestScore[[nextPoint, nextDirection]]
                let nextLowestScore = nextLowestValues?.0 ?? Int.max
                let nextLowestPoints = nextLowestValues?.1 ?? []
                if nextScore < nextLowestScore {
                    lowestScore[[nextPoint, nextDirection]] = (nextScore, nextBestPoints)
                    pointsToVisit.insert([nextPoint, nextDirection])
                } else if nextScore == nextLowestScore {
                    let count = nextLowestPoints.count
                    nextBestPoints.formUnion(nextLowestPoints)
                    lowestScore[[nextPoint, nextDirection]] = (nextScore, nextBestPoints)
                    if nextBestPoints.count > count {
                        pointsToVisit.insert([nextPoint, nextDirection])
                    }
                }
            }
        }
    }

    func part1() -> Int {
        pointsToVisit = []
        lowestScore = [:]
        map = getMap()
        // printMap(map, emptyValue: .empty)
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
        let startDirection = Point(1, 0)
        lowestScore[[startPoint, startDirection]] = (0, [startPoint])
        pointsToVisit.insert([startPoint, startDirection])
        checkFields()
        // printMap2(lowestScore, emptyValue: "#")
        return directions.map {
            lowestScore[[endPoint, $0]]?.0 ?? Int.max
        }.min() ?? -1
    }

    func printMap2<T>(_ map2: [[Point]: T], emptyValue: String) {
        for dir in directions {
            var orderd: [[String]] = []
            var offsetY = 0
            var offsetX = 0
            for (points, value) in map2 {
                let point = points[0]
                let direction = points[1]
                if direction != dir { continue }
                if point.y < 0, offsetY < abs(point.y) {
                    let newOffsetY = abs(point.y)
                    for _ in 0 ..< newOffsetY - offsetY {
                        orderd.insert([], at: 0)
                    }
                    offsetY = newOffsetY
                }
                let y = point.y + offsetY
                while orderd.count <= y {
                    orderd.append([])
                }
                if point.x < 0, offsetX < abs(point.x) {
                    let newOffsetX = abs(point.x)
                    for _ in 0 ..< newOffsetX - offsetX {
                        for currentY in 0 ..< orderd.count {
                            orderd[currentY].insert("|\(emptyValue)|", at: 0)
                        }
                    }
                    offsetX = newOffsetX
                }
                let x = point.x + offsetX
                while orderd[y].count <= x {
                    orderd[y].append("|\(emptyValue)|")
                }
                orderd[y][x] = "|\(value)|"
            }
            printArray2D(orderd)
        }
    }

    func part2() -> Int {
        pointsToVisit = []
        lowestScore = [:]
        map = getMap()
        // printMap(map, emptyValue: .empty)
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
        let startDirection = Point(1, 0)
        lowestScore[[startPoint, startDirection]] = (0, [startPoint])
        pointsToVisit.insert([startPoint, startDirection])
        checkFields()
        // printMap2(lowestScore, emptyValue: "#")
        var totalScore = Int.max
        var totalPoints: Set<Point> = []
        for dir in directions {
            if let values = lowestScore[[endPoint, dir]] {
                if values.0 <= totalScore {
                    totalScore = values.0
                    totalPoints.formUnion(values.1)
                }
            }
        }
        // printSet(totalPoints, value: "O")
        return totalPoints.count
    }
}
