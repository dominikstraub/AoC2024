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

    // part2 #####################

    func printGarden(_ garden: [[String]]) {
        for row in garden {
            for plot in row {
                print(plot, terminator: "")
            }
            print("", terminator: "\n")
        }
    }

    func printGarden<T>(_ garden: Set<Point>, _ plot: T = "X") {
        var orderd: [[String]] = []
        var offsetY = 0
        var offsetX = 0
        for point in garden {
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
                        orderd[currentY].insert(" ", at: 0)
                    }
                }
                offsetX = newOffsetX
            }
            let x = point.x + offsetX
            while orderd[y].count <= x {
                orderd[y].append(" ")
            }
            orderd[y][x] = "\(plot)"
        }
        printGarden(orderd)
    }

    func printGarden<T>(_ garden: Set<Set<Point>>, _ plot: T = "X") {
        var orderd: [[String]] = []
        var offsetY = 0
        var offsetX = 0
        for region in garden {
            for point in region {
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
                            orderd[currentY].insert(" ", at: 0)
                        }
                    }
                    offsetX = newOffsetX
                }
                let x = point.x + offsetX
                while orderd[y].count <= x {
                    orderd[y].append(" ")
                }
                orderd[y][x] = "\(plot)"
            }
        }
        printGarden(orderd)
    }

    func printGarden<T>(_ garden: [Point: T]) {
        var orderd: [[String]] = []
        var offsetY = 0
        var offsetX = 0
        for (point, value) in garden {
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
                        orderd[currentY].insert(" ", at: 0)
                    }
                }
                offsetX = newOffsetX
            }
            let x = point.x + offsetX
            while orderd[y].count <= x {
                orderd[y].append(" ")
            }
            orderd[y][x] = "\(value)"
        }
        printGarden(orderd)
    }

    func sides(_ region: Set<Point>) -> Int {
        visited = []
        var partOfSides: [Point: Int] = [:]
        for point in region {
            let neighbours = findNeighbours(point, region)
            print("point: \(point), neighbours:")
            printGarden(neighbours)
            for (point2, count) in neighbours {
                if partOfSides[point2] == nil {
                    partOfSides[point2] = 0
                }
                partOfSides[point2]! += count
            }
        }
        print("partOfSides:")
        printGarden(partOfSides)
        let regions = getRegions(Set(partOfSides.keys))
        print("regions:")
        printGarden(regions)
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
        print("sides: \(sum)")
        return sum
    }

    func findNeighbours(_ point: Point, _ garden: Set<Point>) -> [Point: Int] {
        if visited.contains(point) { return [:] }
        visited.insert(point)
        var result: [Point: Int] = [:]
        for dir in directions {
            let nextPoint = point + dir
            if garden.contains(nextPoint) {
                for (p, count) in findNeighbours(nextPoint, garden) {
                    result[p] = (result[p] ?? 0) + count
                }
            } else {
                result[nextPoint] = (result[nextPoint] ?? 0) + 1
            }
        }
        return result
    }

    func getRegions(_ garden: Set<Point>) -> Set<Set<Point>> {
        visited = []
        var result: Set<Set<Point>> = []
        for point in garden {
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
        print("garden:")
        printGarden(garden)
        let regions = getRegions(garden)
        var result = 0
        for (plot, regions2) in regions {
            print("plot: \(plot), regions2:")
            printGarden(regions2, plot)
            for points in regions2 {
                print("plot: \(plot), points:")
                printGarden(points, plot)
                result += points.count * sides(points)
            }
        }
        return result
    }
}
