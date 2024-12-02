import Algorithms

struct Day02: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [[Int]] {
        data.split(separator: "\n").map {
            $0.split(separator: " ").compactMap { Int($0) }
        }
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Int {
        var safe = 0
        reports: for report in entities {
            var decreased = false
            var increased = false
            for index in 1 ..< report.count {
                if report[index - 1] < report[index] {
                    increased = true
                } else if report[index - 1] > report[index] {
                    decreased = true
                }
                let diff = abs(report[index - 1] - report[index])
                if diff < 1 || diff > 3 {
                    continue reports
                }
            }
            if decreased && increased {
                continue
            }
            safe += 1
        }
        return safe
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Int {
        var safe = 0
        reports: for report in entities {
            var levelRemoved = false
            var removedIndex: Int?
            var decreased = false
            var increased = false
            for index in 1 ..< report.count {
                let indexOffset = removedIndex == index - 1 ? -1 : 0
                if report[index - 1 + indexOffset] < report[index] {
                    increased = true
                    if decreased {
                        if levelRemoved {
                            continue reports
                        } else {
                            levelRemoved = true
                            removedIndex = index
                            continue
                        }
                    }
                } else if report[index - 1 + indexOffset] > report[index] {
                    decreased = true
                    if increased {
                        if levelRemoved {
                            continue reports
                        } else {
                            levelRemoved = true
                            removedIndex = index
                            continue
                        }
                    }
                }
                let diff = abs(report[index - 1 + indexOffset] - report[index])
                if diff < 1 || diff > 3 {
                    if levelRemoved {
                        continue reports
                    } else {
                        levelRemoved = true
                        removedIndex = index
                        continue
                    }
                }
            }
            if decreased && increased {
                continue
            }
            safe += 1
            print(report)
        }
        return safe
    }
}
