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
        var result = 0
        for (_, regions2) in regions {
            for points in regions2 {
                result += points.count * perimeter(points)
            }
        }
        return result
    }

    func sides(_ regions: Set<Point>) -> Int {
        var partOfSides: [Point: Int] = [:]
        for point in regions {
            let neighbours = findNeighbours(point, regions)
            for point2 in neighbours {
                if partOfSides[point2] == nil {
                    partOfSides[point2] = 0
                }
                partOfSides[point2]! += 1
            }
        }
        let regions = getRegions(Set(partOfSides.keys))
        var sum = 0
        for region in regions {
            var max = 0
            for point in region {
                if max < partOfSides[point]! {
                    max = partOfSides[point]!
                }
            }
            sum += max
        }
        return sum
    }

    func findNeighbours(_ point: Point, _ garden: Set<Point>) -> Set<Point> {
        var result: Set<Point> = [point]
        for dir in directions {
            let nextPoint = point + dir
            if garden.contains(nextPoint) {
                result.formUnion(findNeighbours(nextPoint, garden))
            } else {
                result.insert(nextPoint)
            }
        }
        return result
    }

    func getRegions(_ garden: Set<Point>) -> Set<Set<Point>> {
        visited = []
        var result: Set<Set<Point>> = []
        for point in garden {
            if visited.contains(point) { continue }
            result.insert(findSuroundingPlots(point, garden))
        }
        return result
    }

    func findSuroundingPlots(_ point: Point, _ garden: Set<Point>) -> Set<Point> {
        if visited.contains(point) { return [] }
        visited.insert(point)
        var result: Set<Point> = [point]
        for dir in directions {
            let nextPoint = point + dir
            if !garden.contains(nextPoint) { continue }
            result.formUnion(findSuroundingPlots(nextPoint, garden))
        }
        return result
    }

    func perimeter(_ points: Set<Point>) -> [Point: Int] {
        var result: [Point: Int] = [:]
        for point in points {
            for dir in directions {
                let nextPoint = point + dir
                if !points.contains(nextPoint) {
                    result[nextPoint] = 0
                }
                result[nextPoint]! += 1
            }
        }
        return result
    }

    func part2() -> Int {
        let garden = getGarden()
        let regions = getRegions(garden)
        var result = 0
        for (_, regions2) in regions {
            for points in regions2 {
                result += points.count * sides(points)
            }
        }
        return result
    }
}
