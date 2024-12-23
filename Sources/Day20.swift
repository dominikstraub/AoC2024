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

private struct PointCheat {
    let point: Point
    let cheatsLeft: Int
    let cheatStart: Point?
}

extension PointCheat: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(point)
        hasher.combine(cheatsLeft)
        hasher.combine(cheatStart)
    }
}

@MainActor private var map: FieldMap = [:]

@MainActor private var pointsToVisit: Set<Point> = []
@MainActor private var pointsVisited: Set<Point> = []
@MainActor private var lowestTime: [Point: Int] = [:]
@MainActor private var wallsToCheck: Set<Point> = []
@MainActor private var findingWalls = true
@MainActor private var cheat: Point?

@MainActor private var pointsToVisit2: Set<PointCheat> = []
@MainActor private var pointsVisited2: Set<PointCheat> = []
@MainActor private var lowestTime2: [PointCheat: (time: Int, variations: Int)] = [:]

@MainActor struct Day20: AdventDay {
    nonisolated init(data: String) {
        self.data = data
    }

    var data: String

    private let directions: Set<Point> = [
        Point(0, -1),
        Point(1, 0),
        Point(0, 1),
        Point(-1, 0),
    ]

    private func getMap() -> FieldMap {
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

    private func checkFields() {
        while !pointsToVisit.isEmpty {
            let nextPoint = pointsToVisit.sorted(by: { lowestTime[$0] ?? Int.max < lowestTime[$1] ?? Int.max }).first!
            pointsToVisit.remove(nextPoint)
            visitField(atPoint: nextPoint)
        }
    }

    private func visitField(atPoint currentPoint: Point) {
        for nextDirection in directions {
            let nextPoint = currentPoint + nextDirection
            let nextField = map[nextPoint]
            if nextField == nil { continue }
            if nextPoint != cheat, nextField == .wall { if findingWalls { wallsToCheck.insert(nextPoint) }; continue }

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

    private func checkFieldsWithCheats() {
        while !pointsToVisit2.isEmpty {
            let nextPointCheat = pointsToVisit2.removeFirst()
            visitFieldWithCheats(atPointCheat: nextPointCheat)
        }
    }

    private func visitFieldWithCheats(atPointCheat currentPointCheat: PointCheat) {
        pointsVisited2.insert(currentPointCheat)
        let currentPoint = currentPointCheat.point
        let currentField = map[currentPoint]
        if currentField == .end {
            return
        }
        let cheatsLeft = currentPointCheat.cheatsLeft
        let currentCheatStart = currentPointCheat.cheatStart
        for nextDirection in directions {
            let nextPoint = currentPoint + nextDirection
            let nextField = map[nextPoint]
            if nextField == nil { continue }
            var nextCheatsLeft = cheatsLeft
            var nextCheatStart = currentCheatStart
            if cheatsLeft < 20, cheatsLeft > 0 {
                nextCheatsLeft -= 1
            }
            if nextField == .wall {
                if cheatsLeft <= 1 { continue }
                if cheatsLeft == 20 {
                    nextCheatStart = currentPoint
                    nextCheatsLeft -= 1
                }
            }

            guard let currentValues = lowestTime2[currentPointCheat] else { continue }
            let currentTime = currentValues.time
            let nextTime = currentTime + 1

            if nextTime < lowestTime[nextPoint] ?? Int.max {
                let nextPointCheat = PointCheat(point: nextPoint, cheatsLeft: nextCheatsLeft, cheatStart: nextCheatStart)

                let nextLowestValues = lowestTime2[nextPointCheat] ?? (time: Int.max, variations: 0)
                lowestTime2[nextPointCheat] = (time: nextTime, variations: nextLowestValues.variations + currentValues.variations)
                if pointsVisited2.contains(nextPointCheat) { continue }
                pointsToVisit2.insert(nextPointCheat)
            }
        }
    }

    func part1() -> Int {
        pointsToVisit = []
        pointsVisited = []
        lowestTime = [:]
        map = [:]
        wallsToCheck = []
        cheat = nil
        findingWalls = true

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
        let initialBestTime = lowestTime[endPoint]
        print(initialBestTime!)
        findingWalls = false

        var result = 0
        while !wallsToCheck.isEmpty {
            pointsToVisit = []
            pointsVisited = []
            lowestTime = [:]

            let wall = wallsToCheck.removeFirst()
            cheat = wall

            lowestTime[startPoint] = 0
            pointsToVisit.insert(startPoint)
            checkFields()
            let time = lowestTime[endPoint]
            if time! + 99 < initialBestTime! {
                result += 1
            }
        }

        return result
    }

    func part2() -> Int {
        pointsToVisit = []
        pointsVisited = []
        lowestTime = [:]
        map = [:]
        wallsToCheck = []
        cheat = nil
        findingWalls = false

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
        let initialBestTime = lowestTime[endPoint]

        let maxCheats = 20
        pointsToVisit2 = []
        lowestTime2 = [:]

        let startPointCheat = PointCheat(point: startPoint, cheatsLeft: maxCheats, cheatStart: nil)

        lowestTime2[startPointCheat] = (time: 0, variations: 1)
        pointsToVisit2.insert(startPointCheat)
        checkFieldsWithCheats()

        var result = 0
        for cheats in 0 ..< 20 {
            for (point, _) in map {
                let endPointCheat = PointCheat(point: endPoint, cheatsLeft: cheats, cheatStart: point)
                if let values = lowestTime2[endPointCheat], values.time < initialBestTime! {
                    result += values.variations
                }
            }
        }

        return result
    }
}
