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

    func getPaths(_ point: Point, _ path: Set<Point>) -> Set<Point> {
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
            niner.formUnion(getPaths(nextPoint, path))
        }
        return niner
    }

    func getAllPaths(_ point: Point, _ path: Set<Point>) -> Int {
        guard let field = map[point] else {
            return 0
        }
        if path.contains(point) {
            return 0
        }
        var path = path
        path.insert(point)
        // print(path)
        if field == 9 {
            return 1
        }
        let directions = [
            Point(0, -1),
            Point(1, 0),
            Point(0, 1),
            Point(-1, 0),
        ]
        var score = 0
        for dir in directions {
            let nextPoint = point + dir
            guard let nextField = map[nextPoint] else {
                continue
            }
            if nextField != field + 1 {
                continue
            }
            score += getAllPaths(nextPoint, path)
        }
        return score
    }

    func getNext(_ point: Point) -> Point {
        return point
    }

    func part1() -> Int {
        // print(map)
        var totalScore = 0
        for (point, field) in map where field == 0 {
            totalScore += getPaths(point, []).count
        }
        return totalScore
    }

    func part2() -> Int {
        // print(map)
        var totalScore = 0
        for (point, field) in map where field == 0 {
            totalScore += getAllPaths(point, [])
        }
        return totalScore
    }
}
