import Algorithms
import Foundation

@MainActor var visited: Set<Point> = []

@MainActor struct Day12: AdventDay {
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

    func getGarden() -> [Point: String] {
        var result: [Point: String] = [:]
        for (y, row) in data.split(separator: "\n").enumerated() {
            for (x, plot) in row.enumerated() {
                result[Point(x, y)] = String(plot)
            }
        }
        return result
    }

    func getRegions(_ garden: [Point: String]) -> [String: Set<Set<Point>>] {
        visited = []
        var result: [String: Set<Set<Point>>] = [:]
        for (point, plot) in garden {
            if visited.contains(point) { continue }
            if result[plot] == nil {
                result[plot] = []
            }
            result[plot]!.insert(findSuroundingPlots(plot, point, garden))
        }
        return result
    }

    func findSuroundingPlots(_ plot: String, _ point: Point, _ garden: [Point: String]) -> Set<Point> {
        if visited.contains(point) { return [] }
        visited.insert(point)
        var result: Set<Point> = [point]
        for dir in directions {
            let nextPoint = point + dir
            if garden[nextPoint] != plot { continue }
            result.formUnion(findSuroundingPlots(plot, nextPoint, garden))
        }
        return result
    }

    func perimeter(_ points: Set<Point>) -> Int {
        var result = 0
        for point in points {
            for dir in directions where !points.contains(point + dir) {
                result += 1
            }
        }
        return result
    }

    func part1() -> Int {
        let garden = getGarden()
        let regions = getRegions(garden)
        // print(garden)
        // print(regions)
        var result = 0
        for (_, regions2) in regions {
            for points in regions2 {
                let area = points.count
                let per = perimeter(points)
                let price = area * per
                // print("\(plot): \(area) * \(per) = \(price)")
                result += price
            }
        }
        return result
    }

    func part2() -> Any {
        return -1
    }
}
