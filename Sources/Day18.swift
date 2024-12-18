import Algorithms
import Foundation

@MainActor private var pointsToVisit: Set<Point> = []
@MainActor private var shortesDistance: [Point: Int] = [:]
@MainActor private var map: Set<Point> = []

@MainActor struct Day18: AdventDay {
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

    func getBytes(count: Int) -> Set<Point> {
        var result: Set<Point> = []
        for (index, line) in data.split(separator: "\n").enumerated() {
            if index >= count {
                break
            }
            let parts = line.split(separator: ",")
            result.insert(Point(Int(parts[0])!, Int(parts[1])!))
        }
        return result
    }

    func checkFields() {
        while !pointsToVisit.isEmpty {
            let nextPoint = pointsToVisit.removeFirst()
            visitField(atPoint: nextPoint)
        }
    }

    func visitField(atPoint currentPoint: Point) {
        // print("=====")
        // printMap(shortesDistance, emptyValue: 0)
        // print("=====")
        for nextDirection in directions {
            let nextPoint = currentPoint + nextDirection
            if map.contains(nextPoint) { continue }
            if nextPoint.x < 0 || nextPoint.y < 0 || nextPoint.x > 70 || nextPoint.y > 70 { continue }

            guard let currentDistance = shortesDistance[currentPoint] else { continue }
            let nextDistance = currentDistance + 1

            let currentShortestDistance = shortesDistance[nextPoint] ?? Int.max
            if nextDistance < currentShortestDistance {
                shortesDistance[nextPoint] = nextDistance
                pointsToVisit.insert(nextPoint)
            }
        }
    }

    func part1() -> Int {
        pointsToVisit = []
        shortesDistance = [:]
        map = getBytes(count: 1024)
        let startPoint = Point(0, 0)
        let endPoint = Point(70, 70)
        shortesDistance[startPoint] = 0
        pointsToVisit.insert(startPoint)
        checkFields()
        printMap(shortesDistance, emptyValue: 0)
        printSet(map, value: "#")
        return shortesDistance[endPoint]!
    }

    func part2() -> Any {
        return -1
    }
}
