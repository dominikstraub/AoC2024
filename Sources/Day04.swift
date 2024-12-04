import Algorithms
import Foundation

struct Day04: AdventDay {
    var data: String

    var field: [String] {
        data.split(separator: "\n").compactMap { String($0) }
    }

    func part1() -> Int {
        var count = 0
        for y in 0 ..< field.count {
            for x in 0 ..< field[y].count where field[y][x] == "X" {
                count += xmasCount(x: x, y: y)
            }
        }
        return count
    }

    func xmasCount(x: Int, y: Int) -> Int {
        var count = 0
        let directions = [
            (1, 0),
            (1, 1),
            (0, 1),
            (-1, 1),
            (-1, 0),
            (-1, -1),
            (0, -1),
            (1, -1),
        ]
        dir: for dir in directions {
            for (index, letter) in "XMAS".enumerated() where !checkLetter(x: x, y: y, xDir: dir.0, yDir: dir.1, offset: index, letter: String(letter)) {
                continue dir
            }
            count += 1
        }
        return count
    }

    func checkLetter(x: Int, y: Int, xDir: Int, yDir: Int, offset: Int, letter: String) -> Bool {
        if let line = field[safe: y + (offset * yDir)], let char = line[safe: x + (offset * xDir)] {
            return String(char) == letter
        }
        return false
    }

    func part2() -> Int {
        var count = 0
        for y in 0 ..< field.count {
            for x in 0 ..< field[y].count where field[y][x] == "A" {
                count += xmasesCount(x: x, y: y)
            }
        }
        return count
    }

    func xmasesCount(x: Int, y: Int) -> Int {
        let options = [
            [
                ("M", -1, -1),
                ("S", 1, 1),
            ],
            [
                ("M", 1, 1),
                ("S", -1, -1),
            ],
            [
                ("M", 1, -1),
                ("S", -1, 1),
            ],
            [
                ("M", -1, 1),
                ("S", 1, -1),
            ],
        ]
        var masCount = 0
        opt: for opt in options {
            for letterData in opt where !checkLetter(x: x, y: y, xDir: letterData.1, yDir: letterData.2, offset: 1, letter: letterData.0) {
                continue opt
            }
            masCount += 1
        }
        if masCount >= 2 {
            return 1
        } else {
            return 0
        }
    }
}
