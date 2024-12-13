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

    func getSideCount(_ region: Set<Point>) -> Int {
        visited = []
        var allFences: Set<Point> = []
        for point in region {
            let fences = findFences(point, region)
            // print("point: \(point), fences:")
            printGarden(fences)
            allFences.formUnion(fences)
        }
        // print("allFences:")
        printGarden(allFences)
        let sides = getSides(allFences)
        // print("sides:")
        printGarden(sides)
        // print(sides.count)
        return sides.count
    }

    func findFences(_ point: Point, _ garden: Set<Point>) -> Set<Point> {
        if visited.contains(point) { return [] }
        visited.insert(point)
        var result: Set<Point> = []
        for dir in directions {
            let nextPoint = point + dir
            if garden.contains(nextPoint) {
                result.formUnion(findFences(nextPoint, garden))
            } else {
                let fence = (point * Point(2, 2)) + dir + Point(1, 1)
                result.insert(fence)
            }
        }
        return result
    }

    func getSides(_ allFences: Set<Point>) -> Set<Set<Point>> {
        visited = []
        var result: Set<Set<Point>> = []
        for fence in allFences {
            let sideParts = findSideParts(fence, allFences)
            if sideParts.count > 0 {
                result.insert(sideParts)
                // print("side:")
                printGarden(sideParts)
            }
        }
        return result
    }

    func findSideParts(_ fence: Point, _ allFences: Set<Point>) -> Set<Point> {
        if visited.contains(fence) { return [] }
        visited.insert(fence)
        var result: Set<Point> = [fence]
        if fence.y % 2 == 0 {
            for dir in directions.filter({ $0.y == 0 }) {
                let nextFence = fence + (dir * Point(2, 2))
                if !allFences.contains(nextFence) { continue }
                let perpFence1 = fence + (dir + dir.rotatedClock90)
                let perpFence2 = fence + (dir + dir.rotatedCounterClock90)
                if allFences.contains(perpFence1), allFences.contains(perpFence2) { continue }
                result.formUnion(findSideParts(nextFence, allFences))
            }
        } else {
            for dir in directions.filter({ $0.x == 0 }) {
                let nextFence = fence + (dir * Point(2, 2))
                if !allFences.contains(nextFence) { continue }
                let perpFence1 = fence + (dir + dir.rotatedClock90)
                let perpFence2 = fence + (dir + dir.rotatedCounterClock90)
                if allFences.contains(perpFence1), allFences.contains(perpFence2) { continue }
                result.formUnion(findSideParts(nextFence, allFences))
            }
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
        // print("garden:")
        printGarden(garden)
        let regions = getRegions(garden)
        var result = 0
        for (plot, regions2) in regions {
            // print("plot: \(plot), regions2:")
            printGarden(regions2, plot)
            for points in regions2 {
                // print("plot: \(plot), points:")
                printGarden(points, plot)
                result += points.count * getSideCount(points)
            }
        }
        return result
    }
}
