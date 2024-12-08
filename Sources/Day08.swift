import Algorithms
import Foundation

struct Day08: AdventDay {
    var data: String

    var antennas: [String: [Point]] {
        var result: [String: [Point]] = [:]
        for (y, row) in data.split(separator: "\n").enumerated() {
            for (x, field) in row.enumerated() where field != "." {
                let frequency = String(field)
                if result[frequency] == nil {
                    result[frequency] = []
                }
                result[frequency]!.append(Point(x: x, y: y))
            }
        }
        return result
    }

    var size: Point {
        let rows = data.split(separator: "\n")
        return Point(x: rows[0].count, y: rows.count)
    }

    func getAntinodes(_ antennaA: Point, _ antennaB: Point) -> [Point] {
        var antinodes: [Point] = []
        let distance = (x: antennaA.x - antennaB.x, y: antennaA.y - antennaB.y)
        let antinodeNegA = Point(x: antennaA.x - distance.x, y: antennaA.y - distance.y)
        if antinodeNegA == antennaB {
            let antinodeNegB = Point(x: antennaB.x - distance.x, y: antennaB.y - distance.y)
            if antinodeNegB.x >= 0, antinodeNegB.y >= 0, antinodeNegB.x < size.x, antinodeNegB.y < size.y {
                antinodes.append(antinodeNegB)
            }
        } else {
            if antinodeNegA.x >= 0, antinodeNegA.y >= 0, antinodeNegA.x < size.x, antinodeNegA.y < size.y {
                antinodes.append(antinodeNegA)
            }
        }

        let antinodePosA = Point(x: antennaA.x + distance.x, y: antennaA.y + distance.y)
        if antinodePosA == antennaB {
            let antinodePosB = Point(x: antennaB.x + distance.x, y: antennaB.y + distance.y)
            if antinodePosB.x >= 0, antinodePosB.y >= 0, antinodePosB.x < size.x, antinodePosB.y < size.y {
                antinodes.append(antinodePosB)
            }
        } else {
            if antinodePosA.x >= 0, antinodePosA.y >= 0, antinodePosA.x < size.x, antinodePosA.y < size.y {
                antinodes.append(antinodePosA)
            }
        }
        return antinodes
    }

    func part1() -> Int {
        print(antennas)
        var antinodes: Set<Point> = []
        for (_, antennas) in antennas {
            for (index, antennaA) in antennas.enumerated() {
                for antennaB in antennas[index + 1 ..< antennas.count] {
                    antinodes.formUnion(getAntinodes(antennaA, antennaB))
                }
            }
        }
        print(antinodes)
        return antinodes.count
    }

    func part2() -> Any {
        return -1
    }
}
