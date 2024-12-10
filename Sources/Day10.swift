import Algorithms
import Foundation

struct Day10: AdventDay {
    var data: String

    var map: [Point: Int] {
        var result: [Point: Int] = [:]
        for (y, row) in data.split(separator: "\n").enumerated() {
            for (x, field) in row.enumerated() {
                result[Point(x, y)] = Int(field)
            }
        }
        return result
    }

    func getScore(_ point: Point, _ path: Set<Point>) -> Set<Point> {
        guard let field = map[point] else {
            return []
        }
        if path.contains(point) {
            return []
        }
        var path = path
        path.insert(point)
        // print(path)
        if field == 9 {
            return [point]
        }
        let directions = [
            Point(0, -1),
            Point(1, 0),
            Point(0, 1),
            Point(-1, 0),
        ]
        var niner: Set<Point> = []
        for dir in directions {
            let nextPoint = point + dir
            guard let nextField = map[nextPoint] else {
                continue
            }
            if nextField != field + 1 {
                continue
            }
            niner.formUnion(getScore(nextPoint, path))
        }
        return niner
    }

    func getNext(_ point: Point) -> Point {
        return point
    }

    func part1() -> Int {
        // print(map)
        var totalScore = 0
        for (point, field) in map where field == 0 {
            totalScore += getScore(point, []).count
        }
        return totalScore
    }

    func part2() -> Any {
        return -1
    }
}
