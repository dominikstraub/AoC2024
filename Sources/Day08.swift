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

    func getAntinodes(_ antennaA: Point, _ antennaB: Point) -> Set<Point> {
        var antinodes: Set<Point> = []
        let distance = antennaA - antennaB
        let antinodeNegA = antennaA - distance
        if antinodeNegA == antennaB {
            let antinodeNegB = antennaB - distance
            if antinodeNegB.x >= 0, antinodeNegB.y >= 0, antinodeNegB.x < size.x, antinodeNegB.y < size.y {
                antinodes.insert(antinodeNegB)
            }
        } else {
            if antinodeNegA.x >= 0, antinodeNegA.y >= 0, antinodeNegA.x < size.x, antinodeNegA.y < size.y {
                antinodes.insert(antinodeNegA)
            }
        }

        let antinodePosA = antennaA + distance
        if antinodePosA == antennaB {
            let antinodePosB = antennaB + distance
            if antinodePosB.x >= 0, antinodePosB.y >= 0, antinodePosB.x < size.x, antinodePosB.y < size.y {
                antinodes.insert(antinodePosB)
            }
        } else {
            if antinodePosA.x >= 0, antinodePosA.y >= 0, antinodePosA.x < size.x, antinodePosA.y < size.y {
                antinodes.insert(antinodePosA)
            }
        }
        return antinodes
    }

    func getAntinodesWithHarmonics(_ antennaA: Point, _ antennaB: Point) -> Set<Point> {
        var antinodes: Set<Point> = [antennaB, antennaB]
        var multiplier = 0
        while true {
            var antinodeFound = false
            let distance = (antennaA - antennaB) * multiplier
            let antinodeNegA = antennaA - distance
            if antinodeNegA == antennaB {
                let antinodeNegB = antennaB - distance
                if antinodeNegB.x >= 0, antinodeNegB.y >= 0, antinodeNegB.x < size.x, antinodeNegB.y < size.y {
                    antinodes.insert(antinodeNegB)
                    antinodeFound = true
                }
            } else {
                if antinodeNegA.x >= 0, antinodeNegA.y >= 0, antinodeNegA.x < size.x, antinodeNegA.y < size.y {
                    antinodes.insert(antinodeNegA)
                    antinodeFound = true
                }
            }

            let antinodePosA = antennaA + distance
            if antinodePosA == antennaB {
                let antinodePosB = antennaB + distance
                if antinodePosB.x >= 0, antinodePosB.y >= 0, antinodePosB.x < size.x, antinodePosB.y < size.y {
                    antinodes.insert(antinodePosB)
                    antinodeFound = true
                }
            } else {
                if antinodePosA.x >= 0, antinodePosA.y >= 0, antinodePosA.x < size.x, antinodePosA.y < size.y {
                    antinodes.insert(antinodePosA)
                    antinodeFound = true
                }
            }
            if !antinodeFound {
                break
            }
            multiplier += 1
        }
        return antinodes
    }

    func part1() -> Int {
        var antinodes: Set<Point> = []
        for (_, antennas) in antennas {
            for (index, antennaA) in antennas.enumerated() {
                for antennaB in antennas[index + 1 ..< antennas.count] {
                    antinodes.formUnion(getAntinodes(antennaA, antennaB))
                }
            }
        }
        return antinodes.count
    }

    func part2() -> Int {
        var antinodes: Set<Point> = []
        for (_, antennas) in antennas {
            for (index, antennaA) in antennas.enumerated() {
                for antennaB in antennas[index + 1 ..< antennas.count] {
                    antinodes.formUnion(getAntinodesWithHarmonics(antennaA, antennaB))
                }
            }
        }
        return antinodes.count
    }
}
